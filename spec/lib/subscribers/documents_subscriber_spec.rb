require 'spec_helper'

describe DocumentsSubscriber  do
  subject { DocumentsSubscriber.new }

  let(:locale) { Fabricate :locale }

  let(:foo_page) { Fabricate :page, :parent => locale, :template => 'main_page' }
  let(:bar_page) { Fabricate :page, :parent => locale, :slug => 'bar', :template => 'main_page' }

  let(:foo_part) { Fabricate :documents_item_part, :node => foo_page, :documents_contexts => [1, 2], :region => 'content', :documents_kind => 'documents' }
  let(:bar_part) { Fabricate :documents_item_part, :node => bar_page, :documents_contexts => [2], :region => 'content', :documents_kind => 'projects' }

  let(:baz_part) { Fabricate :documents_item_part, :node => locale, :documents_contexts => [3], :region => 'content', :documents_kind => 'documents' }

  before { DocumentsItemPart.any_instance.stub(:index) }

  before { foo_part; bar_part; baz_part }

  let(:message) {
    { 'id' => '222', 'context_id' => '2', 'kind' => 'document' }
  }

  context '#add' do
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "#{foo_page.url}-/222/") }
    before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'add', "#{bar_page.url}-/222/") }
    before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'add', "#{locale.url}-/222/") }

    specify { subject.add message }
  end

  context '#remove' do
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', "#{foo_page.url}-/222/") }
    before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'remove', "#{bar_page.url}-/222/") }
    before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'remove', "#{locale.url}-/222/") }

    specify { subject.remove message }
  end
end
