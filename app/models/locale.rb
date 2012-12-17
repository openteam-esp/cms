class Locale < Node
  validates :slug, :presence => true

  has_enum :slug

  validates_presence_of :parent, :slug, :template
  alias :site :parent
end

# == Schema Information
#
# Table name: nodes
#
#  ancestry             :string(255)
#  ancestry_depth       :integer          default(0)
#  client_url           :string(255)
#  created_at           :datetime         not null
#  id                   :integer          not null, primary key
#  in_navigation        :boolean
#  navigation_group     :string(255)
#  navigation_position  :integer
#  navigation_title     :string(255)
#  page_for_redirect_id :integer
#  route                :text
#  slug                 :string(255)
#  template             :string(255)
#  title                :string(255)
#  type                 :string(255)
#  updated_at           :datetime         not null
#  weight               :string(255)
#

