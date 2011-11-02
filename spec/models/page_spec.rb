require 'spec_helper'

describe Page do
  it { should belong_to :locale }
  it { should belong_to :template }
end
