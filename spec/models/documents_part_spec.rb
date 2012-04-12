# encoding: utf-8

require 'spec_helper'

describe DocumentsPart do
  subject { Fabricate :documents_part }

  it { should normalize_attribute(:documents_contexts).from(['', '', '1', '2']).to([1, 2]) }
end
