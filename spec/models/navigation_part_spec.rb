require 'spec_helper'

describe NavigationPart do
  it { should belong_to :from_node }
  it { should validate_presence_of :from_node }
  it { should validate_presence_of :navigation_level }
  it { should validate_presence_of :navigation_selected_level }
end

# == Schema Information
#
# Table name: parts
#
#  id                        :integer         not null, primary key
#  html_content_id           :integer
#  created_at                :datetime
#  updated_at                :datetime
#  region                    :string(255)
#  type                      :string(255)
#  node_id                   :integer
#  navigation_level          :integer
#  navigation_selected_level :integer
#  navigation_from_id        :integer
#

