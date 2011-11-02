class Site < ActiveRecord::Base
  has_many :locales
  has_many :templates
end
