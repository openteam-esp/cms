class Template < ActiveRecord::Base
  belongs_to :site
  has_many :regions
end
