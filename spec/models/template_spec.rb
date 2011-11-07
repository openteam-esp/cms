require 'spec_helper'

describe Template do
  it { should belong_to :site }
  it { should have_many :regions }
end

# == Schema Information
#
# Table name: templates
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  site_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

