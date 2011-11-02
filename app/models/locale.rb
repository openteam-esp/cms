class Locale < ActiveRecord::Base
  belongs_to :site
  has_many :pages
end
# == Schema Information
#
# Table name: locales
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  site_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

