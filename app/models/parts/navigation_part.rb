class NavigationPart < Part
  belongs_to :from_node, :foreign_key => :navigation_from_id, :class_name => 'Node'

  validates_presence_of :from_node, :start_level, :end_level, :extra_active, :extra_inactive

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    super_puper_function(from_node)
  end

  def super_puper_function(node_obj, res = {})
    node_obj.children.each do |child|
      res.merge!('title' => child.title)
      res.merge!('children' => super_puper_function(child, res)) if child.children.any?
      #res.merge!(child.slug => hash)
    end
    res
  end

  def ololo(node)
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                        :integer         not null, primary key
#  html_content_id           :integer
#  created_at                :datetime
#  updated_at                :datetime
#  region                    :string(255)
#  type                      :string(255)
#  node_id                   :integer
#  navigation_level          :integer
#  navigation_selected_level :integer
#  navigation_from_id        :integer
#

