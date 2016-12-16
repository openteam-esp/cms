class Site < Node
  attr_accessible :client_url

  scope :ordered, order('title')

  validates :slug, :client_url, :presence => true

  delegate :parts, :to => :default_locale
  delegate :template, :to => :default_locale

  has_one :setup, dependent: :destroy
  has_many :locale_associations, :dependent => :destroy

  after_create :create_stuff

  def create_stuff
    self.site_setting = Setup.create! site_id: id

    self.locales.create slug: 'ru',
      title: 'Главная',
      template: 'main_page',
      in_navigation: true,
      navigation_position: 1

    save!
  end

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
#  id                    :integer          not null, primary key
#  slug                  :string(255)
#  title                 :text
#  ancestry              :string(255)
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  route                 :text
#  template              :string(255)
#  client_url            :string(255)
#  in_navigation         :boolean
#  navigation_group      :string(255)
#  navigation_position   :integer
#  navigation_title      :text
#  ancestry_depth        :integer          default(0)
#  page_for_redirect_id  :integer
#  weight                :string(255)
#  external_link         :text
#  alternative_title     :text
#  locale_association_id :integer
#
