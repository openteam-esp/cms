require 'spec_helper'

describe Site do
  it { should have_many :locales }
  it { should have_many :templates }
end
