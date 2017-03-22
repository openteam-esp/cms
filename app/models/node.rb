class Node < ActiveRecord::Base
  attr_accessible :slug, :template, :title,
                  :navigation_title, :navigation_group, :navigation_position,
                  :in_navigation, :page_for_redirect_id, :external_link,
                  :alternative_title

  attr_accessor :navigation_position_param, :parts_params, :resource_id

  has_many :parts

  belongs_to :locale_association

  validates :slug, format: { with: /\A[[:alnum:]_\.-]+\z/ }

  validates_uniqueness_of :slug, scope: :ancestry

  after_destroy :unindex

  default_scope order: [:weight]

  delegate :weight, to: :parent, prefix: true, allow_nil: true

  scope :navigable, where(in_navigation: true)

  delegate :templates, to: :site

  attr_accessible :meta_attributes
  has_one :meta, dependent: :destroy
  accepts_nested_attributes_for :meta, allow_destroy: true

  default_value_for :in_navigation, true
  default_value_for :parts_params,  {}

  acts_as_list column: :navigation_position

  has_ancestry cache_depth: true
  alias site root

  normalize_attribute :title, with: [:gilensize_as_text, :squish]
  normalize_attribute :slug, with: [:strip, { truncate: { length: 255 } }]

  # NOTE: чтобы не вызавался для новой записи
  before_update :unindex_subtree, unless: :id_changed?

  after_save :cache_route

  after_save :set_navigation_position_and_recalculate_weights

  # NOTE: чтобы не вызавался для новой записи
  after_save :index_subtree, unless: :id_changed?

  audited

  def absolute_depth
    ancestry_depth + context.depth + 1
  end

  def to_json
    {
      'page' => {
        'title' => node_for_json.page_title,
        'navigation_title' => node_for_json.navigation_title,
        'alternative_title' => node_for_json.alternative_title,
        'slug' => node_for_json.slug,
        'template' => node_for_json.template,
        'external_link' => node_for_json.external_link,
        'meta' => node_for_json.meta,
        'related_pages' => related_pages,
        'regions' => node_for_json.regions.inject({}) do |hash, region|
          hash.merge(
            region => ((part = node_for_json.part_for(region, true)).nil? ? nil : part.to_json)
          )
        end
      }
    }
  end

  def to_s
    title
  end

  def related_pages
    if first_page_with_relation = recurcusive_parent_search(self)
      (first_page_with_relation.locale_association.pages - [first_page_with_relation]).each_with_object({}) { |page, hash| hash[page.locale.slug] = page.page_route; hash }
    end
  rescue
    (site.locales - [self]).each_with_object({}) { |page, hash| hash[page.slug] = page.page_route; hash }
  end

  def recurcusive_parent_search(node)
    node.locale_association || node.parent.nil? ? node : recurcusive_parent_search(node.parent)
  end

  def pages
    Page.where(ancestry: child_ancestry)
  end

  def templates
    site.setup.templates.pluck(:title).compact
  rescue
    templates_hash.keys
  end

  def configurable_regions
    regions_with_option 'configurable'
  end

  def indexable_regions
    regions_with_option 'indexable'
  end

  def required_regions
    regions_with_option 'required'
  end

  def scope_condition
    "ancestry = '#{ancestry}'"
  end

  def regions
    result = required_regions

    result << parts.map(&:region)

    result.flatten.uniq
  end

  def page_title
    @page_title = [title]
    @page_title << content_part.page_title if content_part.respond_to?(:page_title)
    @page_title.compact.reverse.join(' | ')
  end

  def page_route
    content_part.respond_to?(:parts_params) ? "#{route_without_site}#{content_part.parts_params}" : route_without_site
  end

  def content_part
    part_for('content_first')
  end

  def part_for(region, select_from_parents = nil)
    @parts ||= {}

    return @parts[region] if @parts.key?(region)

    part = parts.where(region: region).first

    part ||= Part.where(region: region, node_id: path_ids).last if select_from_parents

    if part
      part.current_node = self
      part.params = parts_params ? (parts_params[part.type.underscore.gsub('_part', '')] || {}) : {}
      part.params['page'] = parts_params[:page] if parts_params && parts_params[:page]
      part.resource_id = resource_id
    end

    @parts[region] = part
  end

  def node_route
    route
  end

  def route_without_site
    node_route.try :gsub, /^#{site.slug}/, ''
  end

  def update_route
    prepare_route
    save
  end

  def prepare_route
    self.route = parent ? "#{parent.route}/#{slug}" : slug
  end

  def update_weight
    update_attribute(:weight, weights.join('/'))
  end

  def nodes_from_this_site
    site.descendants
  end

  def site_settings
    @site_settings ||= YAML.load_file(Rails.root.join('config/sites.yml')).to_hash['sites'][site.slug]
  end

  def templates_hash
    raise "Site not found! Set templates settings for site [slug: #{site.slug}, title: #{site.title}] in config/sites.yml" unless site_settings.present?
    site_settings.try(:[], 'templates')
  end

  def url
    "#{site.client_url}#{route_without_site}"
  end

  def cache_route!
    prepare_route
    Node.skip_callback(:save, :after, :cache_route)
    save!
    descendants.map(&:update_route)
    Node.set_callback(:save, :after, :cache_route)
  end

  def reindex
    unindex
    index
  end

  def unindex
    unless ancestry_callbacks_disabled?
      indexable_parts.select { |part| part.respond_to?(:additional_url_for_remove) }.map(&:additional_url_for_remove).compact.each do |url|
        MessageMaker.make_message('esp.cms.searcher', 'remove', url) if Rails.env.production?
      end
      MessageMaker.make_message('esp.cms.searcher', 'remove', url) if Rails.env.production?
    end
  end

  def index
    indexable_parts.map(&:index)
  end

  private

  def indexable_parts
    parts.select(&:indexable?)
  end

  def node_for_json
    self
  end

  def regions_with_option(option)
    site.setup.templates.find_by_title(template).regions.where("#{option} = ?", true).pluck(:title).compact
  rescue
    templates_hash[template].select { | region, options | options[option] }.keys
  end

  def cache_route
    cache_route! if slug_changed? || ancestry_changed?
  end

  def set_navigation_position_and_recalculate_weights
    Node.skip_callback(:save, :after, :set_navigation_position_and_recalculate_weights)
    set_navigation_position
    unless weight == weights.join('/')
      update_weight
      (parent || self).descendants.map(&:update_weight)
    end
    Node.set_callback(:save, :after, :set_navigation_position_and_recalculate_weights)
  end

  def set_navigation_position
    return if navigation_position_param.nil? || navigation_position_param == 'current'
    case navigation_position_param
    when 'first'
      move_to_top unless first?
    when 'last'
      move_to_bottom unless last?
    else
      insert_at(navigation_position_param.to_i)
      move_lower
    end
  end

  def weights
    # NOTE: не больше 100
    [parent_weight, sprintf('%02d', navigation_position)].keep_if(&:present?).join('/').split('/')
  end

  def unindex_subtree
    # NOTE: тут невозможно ориентироваться на ancestry_callbacks_disabled поэтому смотрим на updated_at
    unindex if slug_changed? || (ancestry_changed? && !updated_at_changed?)
  end

  def index_subtree
    subtree.map(&:index) && return if route_changed?
    index if title_changed? || navigation_title_changed? || template_changed?
  end
end

# == Schema Information
#
# Table name: nodes
#
#  id                    :integer          not null, primary key
#  slug                  :string(255)
#  title                 :text
#  ancestry              :string(255)
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  route                 :text
#  template              :string(255)
#  client_url            :string(255)
#  in_navigation         :boolean
#  navigation_group      :string(255)
#  navigation_position   :integer
#  navigation_title      :text
#  ancestry_depth        :integer          default(0)
#  page_for_redirect_id  :integer
#  weight                :string(255)
#  external_link         :text
#  alternative_title     :text
#  locale_association_id :integer
#
