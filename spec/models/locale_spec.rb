require 'spec_helper'

describe Locale do
  it { should belong_to :site }
  it { should have_many :pages }
end
