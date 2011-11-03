class Locale < ActiveRecord::Base

  belongs_to :site
  has_many :pages

  validates_presence_of :locale

  has_enum :locale

  def to_s
    locale
  end

end

# == Schema Information
#
# Table name: locales
#
#  id         :integer         not null, primary key
#  locale     :string(255)
#  site_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

