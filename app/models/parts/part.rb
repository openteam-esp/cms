class Part < ActiveRecord::Base
  belongs_to :page

  validates_presence_of :page, :region
end

# == Schema Information
#
# Table name: parts
#
#  id         :integer         not null, primary key
#  content_id :integer
#  page_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  region     :string(255)
#  type       :string(255)
#

