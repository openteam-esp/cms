require 'spec_helper'

describe Locale do
  it { should validate_presence_of :parent }
  it { should allow_value(:ru).for :slug }
  it { should allow_value(:en).for :slug }
  it { should allow_value(:de).for :slug }
  it { should allow_value(:fr).for :slug }
  it { should_not allow_value(:ru_BU).for :slug }
end

# == Schema Information
#
# Table name: nodes
#
#  id                  :integer         not null, primary key
#  slug                :string(255)
#  title               :string(255)
#  ancestry            :string(255)
#  type                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  route               :text
#  template            :string(255)
#  client_url          :string(255)
#  in_navigation       :boolean
#  navigation_group    :string(255)
#  navigation_position :float
#  navigation_title    :string(255)
#  ancestry_depth      :integer         default(0)
#

