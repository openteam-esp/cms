class Part < ActiveRecord::Base
  belongs_to :content
  belongs_to :page
  belongs_to :region
  validates :content, :page, :region, :presence => true
end
