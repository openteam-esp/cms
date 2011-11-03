require 'spec_helper'

describe Locale do
  it { should belong_to :site }
  it { should have_many :pages }
  it { should validate_presence_of :locale }
  it { should allow_value(:ru).for :locale }
  it { should allow_value(:en).for :locale }
  it { should allow_value(:de).for :locale }
  it { should allow_value(:fr).for :locale }
  it { should_not allow_value(:ru_BU).for :locale }
end

# == Schema Information
#
# Table name: locales
#
#  id         :integer         not null, primary key
#  locale     :string(255)
#  site_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

