require 'spec_helper'

describe Part do
  it { should belong_to :page }
  it { should belong_to :region }
  it { should belong_to :content }
  it { should validate_presence_of :page }
  it { should validate_presence_of :region }
  it { should validate_presence_of :content }
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

