require 'spec_helper'

describe Upload do
  it { should be_valid }
  it { expect{Upload.create! :file => Rails.root.join('spec/fixtures/image.png')}.to change{Image.count}.by(1) }
end
