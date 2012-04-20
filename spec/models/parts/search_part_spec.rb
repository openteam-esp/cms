# encoding: utf-8

require 'spec_helper'

describe SearchPart do
  subject { Fabricate :search_part, :node => Fabricate(:page) }

  it { should validate_presence_of :search_per_page }

  its(:search_per_page) { should == 15 }

  context 'url_for_request' do
    let(:expected_url) { "#{Settings['search_engine.url']}?q=&page=1&per_page=15" }
  end
end
