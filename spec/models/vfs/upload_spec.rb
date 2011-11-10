require 'spec_helper'

describe Upload do
  it { should belong_to :folder }
  it { should validate_presence_of :folder }
  it { Fabricate.build(:folder).should be_valid }
  it { expect{Fabricate :upload, :file => Rails.root.join('spec/fixtures/image.png')}.to change{Image.count}.by(1) }
end
# == Schema Information
#
# Table name: uploads
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  file_name      :string(255)
#  file_mime_type :string(255)
#  file_size      :string(255)
#  file_uid       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

