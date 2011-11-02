require 'spec_helper'

describe Region do
  it { should belong_to :template }
end
