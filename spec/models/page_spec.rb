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
#  id         :integer         not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  ancestry   :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  template   :string(255)
#  route      :text
#

