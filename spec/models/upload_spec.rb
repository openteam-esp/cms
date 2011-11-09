require 'spec_helper'

describe Upload do
  it { should be_valid }
  it { expect{Upload.create! :file => Rails.root.join('spec/fixtures/image.png')}.to change{Image.count}.by(1) }
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

