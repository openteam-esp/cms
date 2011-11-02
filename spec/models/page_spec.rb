require 'spec_helper'

describe Page do
  it { should belong_to :locale }
  it { should belong_to :template }
  it { should have_many :contents }
  it { should validate_presence_of :template }
end
# == Schema Information
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  locale_id  :integer
#  ancestry   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

