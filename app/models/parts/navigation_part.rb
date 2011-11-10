class NavigationPart < Part
  belongs_to :from_node, :foreign_key => :navigation_from_id, :class_name => 'Node'

  validates_presence_of :from_node, :navigation_end_level

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    build_navigation_tree(from_node)
  end

  def build_navigation_tree(node)
    hash = { node.slug => { 'title' => node.title, 'path' => node.path } }
    node.children.each do |child|
        hash[node.slug]['children'] ||= {}
        hash[node.slug]['children'].merge!(build_navigation_tree(child))
    end if node.depth - from_node.depth < navigation_end_level
    hash
  end

end

# == Schema Information
#
# Table name: parts
#
#  id                   :integer         not null, primary key
#  html_content_id      :integer
#  created_at           :datetime
#  updated_at           :datetime
#  region               :string(255)
#  type                 :string(255)
#  node_id              :integer
#  navigation_end_level :integer
#  navigation_from_id   :integer
#

