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

  private
    def node_for_json
      page_for_redirect ? page_for_redirect : super
    end

    def generate_slug
      self.slug = ActiveSupport::Inflector.transliterate(self.title).gsub(/[^[:alnum:]]+/, '-').downcase
    end
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

