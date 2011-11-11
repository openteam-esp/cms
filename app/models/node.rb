class Node < ActiveRecord::Base

  validates :slug, :presence => true, :format => { :with => %r{^[[:alnum:]_\.-]+$} }
  has_ancestry

  has_many :parts

  normalize_attribute :title, :with => [:gilensize_as_text, :squish]
  after_save :cache_route

  alias :site :root
  delegate :templates, :to => :site

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

  def configurable_regions
    hash = {}
    templates_hash[template].select { | region, options | options['configurable'] }.keys.each do |region|
      hash[region] = templates_hash[template][region]['type']
    end
    hash
  end

  def part_for(region)
    parts.where(:region => region).first
  end

  def path
    route.gsub(/^#{site.slug}/, '')
  end

  private
    def cache_route
      self.route = Node.where(:id => path_ids).order(:id).map(&:slug).join('/')
      Node.skip_callback(:save, :after, :cache_route)
      save!
      Node.set_callback(:save, :after, :cache_route)
    end

    def templates_hash
      YAML.load_file(Rails.root.join 'config/sites.yml').to_hash['sites'][site.slug]['templates']
    end
end

# == Schema Information
#
# Table name: nodes
#
#  id         :integer         not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  ancestry   :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  route      :text
#  template   :string(255)
#  client_url :string(255)
#

