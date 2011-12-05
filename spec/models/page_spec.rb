require 'spec_helper'

describe Page do
  it { should have_many :parts }
  it { should validate_presence_of :template }
  it { should validate_presence_of :parent }
  it { Fabricate(:page).locale.slug.should == 'ru' }
  it { Fabricate(:page, :parent => Fabricate(:page)).locale.slug.should == 'ru' }
  it { Fabricate(:page).site.should be_is_root }
  it { Fabricate(:page, :parent => Fabricate(:page)).site.should be_is_root }
end

# == Schema Information
#
# Table name: nodes
#
#  id                  :integer         primary key
#  slug                :string(255)
#  title               :string(255)
#  ancestry            :string(255)
#  type                :string(255)
#  created_at          :timestamp
#  updated_at          :timestamp
#  route               :text
#  template            :string(255)
#  client_url          :string(255)
#  in_navigation       :boolean
#  navigation_group    :string(255)
#  navigation_position :integer
#  navigation_title    :string(255)
#

