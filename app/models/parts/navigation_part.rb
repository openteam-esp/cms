class NavigationPart < Part
  belongs_to :from_node, :foreign_key => :navigation_from_id, :class_name => 'Node'

  validates_presence_of :from_node, :navigation_level, :navigation_selected_level
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

