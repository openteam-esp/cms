class Node < ActiveRecord::Base
  attr_accessor :navigation_position_param, :parts_params, :resource_id

  has_many :parts

  validates :slug, :format => { :with => %r{^[[:alnum:]_\.-]+$} }
  validates_uniqueness_of :slug, :scope => :ancestry

  default_scope :order => [:weight]

  delegate :weight, :to => :parent, :prefix => true, :allow_nil => true

  scope :navigable, where(:in_navigation => true)

  delegate :templates, :to => :site

  default_value_for :in_navigation, true
  default_value_for :parts_params,  {}

  acts_as_list :column => :navigation_position

  has_ancestry :cache_depth => true
  alias :site :root

  normalize_attribute :title, :with => [:gilensize_as_text, :squish]

  after_save :cache_route

  after_save :set_navigation_position_and_recalculate_weights

  def to_json
    {
      'page' => {
        'title' => page_title,
        'template' => template,
        'regions' => regions.inject({}) { |h, r| h.merge(r => part_for(r, true).to_json) }
      }
    }
  end

  def to_s
    title
  end

  def pages
    Page.where(:ancestry => child_ancestry)
  end

  def templates
    templates_hash.keys
  end

  def required_regions
    templates_hash[template].select { | region, options | options['required'] }.keys
  end

  def scope_condition
    "ancestry = '#{self.ancestry}'"
  end

  def regions
    result = required_regions
    result << parts.map(&:region)
    result.flatten.uniq
  end

  def configurable_regions
    templates_hash[template].select { | region, options | options['configurable'] }.keys
  end

  def page_title
    @page_title = [title]
    @page_title << content_part.page_title if content_part.respond_to?(:page_title)
    @page_title.compact.reverse.join(" | ")
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
    part = parts.where(:region => region).first
    part ||= Part.where(:region => region, :node_id => path_ids).first if select_from_parents
    if part
      part.current_node = self
      part.params = parts_params ? (parts_params[part.type.underscore.gsub('_part','')] || {}) : {}
      part.resource_id = self.resource_id
    end
    @parts[region] = part
  end

  def node_route
    self.route
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
    self.update_attribute(:weight, weights.join('/'))
  end

  def nodes_from_this_site
    site.descendants
  end

  def site_settings
    @site_settings ||= YAML.load_file(Rails.root.join 'config/sites.yml').to_hash['sites'][site.slug]
  end

  private
    def cache_route
      return unless self.slug_changed?
      prepare_route
      Node.skip_callback(:save, :after, :cache_route)
      save!
      descendants.map(&:update_route)
      Node.set_callback(:save, :after, :cache_route)
    end

    def templates_hash
      site_settings['templates']
    end

    def set_navigation_position_and_recalculate_weights
      Node.skip_callback(:save, :after, :set_navigation_position_and_recalculate_weights)
      set_navigation_position
      unless weight == weights.join('/')
        self.update_weight
        (parent || self).descendants.map(&:update_weight)
      end
      Node.set_callback(:save, :after, :set_navigation_position_and_recalculate_weights)
    end

    def set_navigation_position
      return if self.navigation_position_param.nil? || self.navigation_position_param == 'current'
      case self.navigation_position_param
      when 'first'
        self.move_to_top unless self.first?
      when 'last'
        self.move_to_bottom unless self.last?
      else
        self.insert_at(self.navigation_position_param)
        self.move_lower
      end
    end

    def weights
      # NOTE: не больше 100
      [parent_weight, sprintf('%02d', navigation_position)].keep_if(&:present?).join('/').split('/')
    end
end

# == Schema Information
#
# Table name: nodes
#
#  id                   :integer         not null, primary key
#  slug                 :string(255)
#  title                :string(255)
#  ancestry             :string(255)
#  type                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  route                :text
#  template             :string(255)
#  client_url           :string(255)
#  in_navigation        :boolean
#  navigation_group     :string(255)
#  navigation_position  :integer
#  navigation_title     :string(255)
#  ancestry_depth       :integer         default(0)
#  page_for_redirect_id :integer
#  weight               :string(255)
#

