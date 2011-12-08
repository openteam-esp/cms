class Node < ActiveRecord::Base
  validates :slug, :format => { :with => %r{^[[:alnum:]_\.-]+$} }

  has_ancestry :cache_depth => true

  has_many :parts

  normalize_attribute :title, :with => [:gilensize_as_text, :squish]
  after_save :cache_route

  default_value_for :in_navigation, true

  scope :navigable, where(:in_navigation => true)
  default_scope :order => [:ancestry_depth, :navigation_position]

  validates_uniqueness_of :slug, :scope => :ancestry

  attr_accessor :parts_params
  default_value_for :parts_params, {}

  attr_accessor :navigation_position_param
  after_save :set_navigation_position

  alias :site :root
  delegate :templates, :to => :site

  acts_as_list :column => :navigation_position

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
    return title unless content_part.respond_to?(:page_title)
    content_part.page_title
  end

  def page_route
    return route_without_site unless content_part.respond_to?(:parts_params)
    "#{route_without_site}#{content_part.parts_params}"
  end

  def content_part
    part_for('content')
  end

  def part_for(region, select_from_parents = nil)
    @parts ||= {}
    return @parts[region] if @parts.key?(region)
    part = parts.where(:region => region).first
    part ||= Part.where(:region => region, :node_id => path_ids).first if select_from_parents
    if part
      part.current_node = self
      part.params = parts_params ? (parts_params[part.type.underscore.gsub('_part','')] || {}) : {}
    end
    @parts[region] = part
  end

  def route_without_site
    route.gsub(/^#{site.slug}/, '')
  end

  private
    def cache_route
      return unless self.slug_changed?
      self.route = parent ? "#{parent.route}/#{slug}" : slug
      Node.skip_callback(:save, :after, :cache_route)
      save!
      Node.set_callback(:save, :after, :cache_route)
      descendants.map(&:save)
    end

    def templates_hash
      @templates_hash ||= YAML.load_file(Rails.root.join 'config/sites.yml').to_hash['sites'][site.slug]['templates']
    end

    def set_navigation_position
      return if self.navigation_position_param.nil? || self.navigation_position_param == 'current'
      Node.skip_callback(:save, :after, :set_navigation_position)
      case self.navigation_position_param
      when 'first'
        self.move_to_top unless self.first?
      when 'last'
        self.move_to_bottom unless self.last?
      else
        self.insert_at(self.navigation_position_param)
      end
      Node.set_callback(:save, :after, :set_navigation_position)
    end

end

# == Schema Information
#
# Table name: nodes
#
#  id                  :integer         not null, primary key
#  slug                :string(255)
#  title               :string(255)
#  ancestry            :string(255)
#  type                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  route               :text
#  template            :string(255)
#  client_url          :string(255)
#  in_navigation       :boolean
#  navigation_group    :string(255)
#  navigation_position :float
#  navigation_title    :string(255)
#  ancestry_depth      :integer         default(0)
#
