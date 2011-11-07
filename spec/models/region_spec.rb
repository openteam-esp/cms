require 'spec_helper'

describe Region do
  it { should belong_to :template }
end

# == Schema Information
#
# Table name: regions
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  template_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#

