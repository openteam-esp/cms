class Page < Node
  belongs_to :page_for_redirect, :class_name => 'Node', :foreign_key => :page_for_redirect_id

  validates_presence_of :parent, :template

  before_validation :generate_slug, :unless => :slug?

  attr_accessible :parent_id, :title, :navigation_title, :slug, :template,
    :in_navigation, :navigation_group, :navigation_position,
    :page_for_redirect_id, :external_link

  default_value_for :navigation_group do |object|
    object.parent.try(:navigation_group)
  end

  validates_url :external_link, :allow_blank => true

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
#  id                   :integer          not null, primary key
#  slug                 :string(255)
#  title                :text
#  ancestry             :string(255)
#  type                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  route                :text
#  template             :string(255)
#  client_url           :string(255)
#  in_navigation        :boolean
#  navigation_group     :string(255)
#  navigation_position  :integer
#  navigation_title     :text
#  ancestry_depth       :integer          default(0)
#  page_for_redirect_id :integer
#  weight               :string(255)
#  external_link        :text
#
