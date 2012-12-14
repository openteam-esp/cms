class Site < Node
  validates :slug, :client_url, :presence => true

  delegate :parts, :to => :default_locale
  delegate :template, :to => :default_locale

  def locales
    Locale.where(:ancestry => child_ancestry)
  end

  def default_locale
    locales.where(:slug => 'ru').first
  end

  def page_title
    default_locale.title
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

