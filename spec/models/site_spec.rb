require 'spec_helper'

describe Site do
  it { should have_many :locales }
  it { should have_many :templates }
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

