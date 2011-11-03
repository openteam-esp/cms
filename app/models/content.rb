class Content < ActiveRecord::Base
  has_many :parts
  has_many :pages, :through => :parts
end
# == Schema Information
#
# Table name: contents
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

