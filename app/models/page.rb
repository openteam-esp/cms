class Page < Node
  belongs_to :page_for_redirect, :class_name => 'Node', :foreign_key => :page_for_redirect_id

  validates_presence_of :parent, :template

  before_validation :generate_slug, :unless => :slug?

  default_value_for :navigation_group do |object|
    object.parent.try(:navigation_group)
  end

  alias :node :parent

  def locale
    ancestors.second
  end

  def node_route
    (page_for_redirect || self).route
  end

  def nodes_from_this_site
    locale.site.descendants
  end

  private
    def generate_slug
      self.slug = ActiveSupport::Inflector.transliterate(self.title).gsub(/[^[:alnum:]]/, '-').downcase
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
#  navigation_position :integer
#  navigation_title    :string(255)
#  ancestry_depth      :integer         default(0)
#

