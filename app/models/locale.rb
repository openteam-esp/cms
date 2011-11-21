class Locale < Node
  has_enum :slug

  validates_presence_of :parent, :slug, :template
  alias :site :parent
end

# == Schema Information
#
# Table name: nodes
#
#  id            :integer         not null, primary key
#  slug          :string(255)
#  title         :string(255)
#  ancestry      :string(255)
#  type          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  route         :text
#  template      :string(255)
#  client_url    :string(255)
#  in_navigation :boolean
#

