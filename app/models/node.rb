class Node < ActiveRecord::Base

  validates :slug, :presence => true, :format => { :with => %r{^[[:alnum:]_\.-]+$} }
  has_ancestry

  has_many :parts

  normalize_attribute :title, :with => [:squish, :gilensize_as_text, :blank]
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

  def template_regions
    templates_hash[template]
  end

  def part_for(region)
    parts.where(:region => region).first
  end

  private
    def cache_route
      self.route = Node.find(path_ids).map(&:slug).join('/')
      Node.skip_callback(:save, :after, :cache_route)
      save!
      Node.set_callback(:save, :after, :cache_route)
    end

    def templates_hash
      Restfulie.at("#{site.client_url}/templates").throw_error.get.resource['templates'] rescue { 'application' => { 'content' => 'html'} }
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

