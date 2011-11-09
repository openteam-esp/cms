class Node < ActiveRecord::Base

  validates :slug, :presence => true, :format => { :with => %r{^[[:alnum:]_\.-]+$} }
  has_ancestry

  has_many :parts

  normalize_attribute :title, :with => [:squish, :gilensize_as_text, :blank]
  after_save :cache_route

  alias :site :root
  delegate :templates, :to => :site

  def to_s
    slug
  end

  def pages
    Page.where(:ancestry => child_ancestry)
  end

  def template_regions
    {'header' => 'navigation', 'content' => 'html', 'footer' => 'html' }
  end

  def content_for(region)
    parts.where(:region => region).first.try(:body)
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
#  template   :string(255)
#  route      :text
#

