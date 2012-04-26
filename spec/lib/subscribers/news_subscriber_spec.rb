require 'spec_helper'

describe NewsSubscriber do
  subject { NewsSubscriber.new }

  let(:locale) { Fabricate :locale }

  let(:foo_page) { Fabricate :page, :parent => locale }
  let(:bar_page) { Fabricate :page, :parent => locale, :slug => 'bar' }

  let(:foo_part) { Fabricate :news_item_part, :node => foo_page, :news_channel => '1' }
  let(:bar_part) { Fabricate :news_item_part, :node => bar_page, :news_channel => '1' }

  let(:baz_part) { Fabricate :news_item_part, :node => locale, :news_channel => '2' }

  before { foo_part; bar_part }

  before { MessageMaker.stub(:make_message) }

  context '#publish' do
    let(:news) {
      { 'channels' => [1, 2], 'slug' => 'ololo' }
    }

    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "#{foo_page.url}-/ololo") }
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "#{bar_page.url}-/ololo") }

    specify { subject.publish news }
  end
end
