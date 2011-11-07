class Site < ActiveRecord::Base

  has_many :locales
  has_many :templates
  has_many :pages

  accepts_nested_attributes_for :locales, :reject_if => :all_blank, :allow_destroy => true
  default_value_for :locales_attributes, [ { :locale => :ru } ]

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

