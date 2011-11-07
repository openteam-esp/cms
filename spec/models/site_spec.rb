require 'spec_helper'

describe Site do
  it { should have_many :locales }
  it { should have_many :templates }
  it { subject.locales.map(&:slug).should == [ 'ru' ] }
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

