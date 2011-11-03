require 'spec_helper'

describe Locale do
  it { should belong_to :site }
  it { should have_many :pages }
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

