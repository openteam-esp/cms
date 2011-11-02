require 'spec_helper'

describe Page do
  it { should belong_to :locale }
  it { should belong_to :template }
  it { should have_many :contents }
  it { should validate_presence_of :template }
end
