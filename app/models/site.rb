class Site < ActiveRecord::Base
  has_many :locales
  has_many :templates

  def to_s
    title
  end

end
# == Schema Information
#
# Table name: sites
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

