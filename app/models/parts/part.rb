class Part < ActiveRecord::Base
  belongs_to :node

  validates_presence_of :node, :region
end

# == Schema Information
#
# Table name: parts
#
#  id                   :integer         not null, primary key
#  html_content_id      :integer
#  created_at           :datetime
#  updated_at           :datetime
#  region               :string(255)
#  type                 :string(255)
#  node_id              :integer
#  navigation_end_level :integer
#  navigation_from_id   :integer
#

