class Part < ActiveRecord::Base
  belongs_to :content
  belongs_to :page
  belongs_to :region
  validates :content, :page, :region, :presence => true
end
# == Schema Information
#
# Table name: parts
#
#  id         :integer         not null, primary key
#  content_id :integer
#  page_id    :integer
#  region_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

