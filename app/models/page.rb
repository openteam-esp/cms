class Page < Node
  validates_presence_of :parent, :template

  after_initialize :set_navigation_group

  default_value_for :navigation_position, 100

  alias :node :parent

  def locale
    ancestors.second
  end

  private
    def set_navigation_group
      self.navigation_group = self.navigation_group || (self.parent.respond_to?(:navigation_group) ? self.parent.navigation_group : nil)
    end
end

# == Schema Information
#
# Table name: nodes
#
#  id                  :integer         primary key
#  slug                :string(255)
#  title               :string(255)
#  ancestry            :string(255)
#  type                :string(255)
#  created_at          :timestamp
#  updated_at          :timestamp
#  route               :text
#  template            :string(255)
#  client_url          :string(255)
#  in_navigation       :boolean
#  navigation_group    :string(255)
#  navigation_position :integer
#  navigation_title    :string(255)
#

