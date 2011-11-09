require 'spec_helper'

describe Part do
  it { should belong_to :page }
  it { should validate_presence_of :page }
  it { should validate_presence_of :region }
end

# == Schema Information
#
# Table name: parts
#
#  id                         :integer         not null, primary key
#  content_id                 :integer
#  page_id                    :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  region                     :string(255)
#  type                       :string(255)
#  node_id                    :integer
#  descendants_level          :integer
#  selected_descendants_level :integer
#

