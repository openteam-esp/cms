class Locale < ActiveRecord::Base
  belongs_to :site
  has_many :pages
end
