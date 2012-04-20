# encoding: utf-8

require 'spec_helper'

describe SearchPart do
  subject { Fabricate :search_part, :node => Fabricate(:page) }

  it { should validate_presence_of :search_per_page }

  its(:search_per_page) { should == 15 }

  context 'url_for_request' do
    let(:expected_url) { "#{Settings['searcher.url']}?url=http://example.com&q=&page=1&per_page=15" }

    let(:mock_object) { Object }

    before { mock_object.stub(:response_status).and_return(200) }
    before { mock_object.stub(:response_hash).and_return({}) }

    before { Requester.should_receive(:new).with(expected_url, 'application/json').and_return(mock_object) }

    it { subject.to_json }
  end
end
