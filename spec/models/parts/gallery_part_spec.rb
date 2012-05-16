require 'spec_helper'

describe GalleryPart do
  it { should belong_to :node }

  let(:page) { Fabricate :page, :template => 'main_page' }
  subject { Fabricate :gallery_part, :node => page, :region => 'content' }

  context 'sending messages' do
    describe '.create' do
      before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "http://example.com/ru/name/") }
      specify { subject }
    end
  end
end
