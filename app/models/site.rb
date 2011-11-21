class Site < Node
  delegate :parts, :to => :default_locale
  delegate :template, :to => :default_locale

  def locales
    Locale.where(:ancestry => child_ancestry)
  end

  def default_locale
    locales.where(:slug => 'ru').first
  end
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

