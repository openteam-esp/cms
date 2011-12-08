class Page < Node
  validates_presence_of :parent, :template

  default_value_for :navigation_position, 100

  default_value_for :navigation_group do |object|
    object.parent.try(:navigation_group)
  end

  alias :node :parent

  def locale
    ancestors.second
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

