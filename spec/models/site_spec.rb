require 'spec_helper'

describe Site do
  it { should have_many :locales }
  it { should have_many :templates }
  it { subject.locales.map(&:locale).should == [ :ru ] }
end

# == Schema Information
#
# Table name: sites
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

