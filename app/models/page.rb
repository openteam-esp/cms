class Page < ActiveRecord::Base
  belongs_to :locale
  belongs_to :template

  has_many :parts
  has_many :contents, :through => :parts

  validates :template, :presence => true
end

# == Schema Information
#
# Table name: pages
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  locale_id   :integer
#  ancestry    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  template_id :integer
#

