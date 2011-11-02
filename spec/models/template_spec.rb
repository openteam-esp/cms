require 'spec_helper'

describe Template do
  it { should belong_to :site }
  it { should have_many :regions }
end
