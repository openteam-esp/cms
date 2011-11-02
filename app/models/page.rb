class Page < ActiveRecord::Base
  belongs_to :locale
  belongs_to :template

  has_many :parts
  has_many :contents, :through => :parts

  validates :template, :presence => true
end
