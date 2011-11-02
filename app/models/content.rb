class Content < ActiveRecord::Base
  has_many :parts
  has_many :pages, :through => :parts
end
