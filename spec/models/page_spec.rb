require 'spec_helper'

describe Page do
  it { should belong_to :template }
  it { should have_many :contents }
  it { should validate_presence_of :template }
  it { should validate_presence_of :parent }
  it { Fabricate(:page).locale.slug.should == 'ru' }
  it { Fabricate(:page, :parent => Fabricate(:page)).locale.slug.should == 'ru' }
end

# == Schema Information
#
# Table name: nodes
#
#  id          :integer         not null, primary key
#  slug        :string(255)
#  title       :string(255)
#  ancestry    :string(255)
#  template_id :integer
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

