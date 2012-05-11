require 'spec_helper'

describe NewsSubscriber do
  subject { NewsSubscriber.new }

  let(:locale) { Fabricate :locale }

  let(:foo_page) { Fabricate :page, :parent => locale, :template => 'main_page' }
  let(:bar_page) { Fabricate :page, :parent => locale, :slug => 'bar', :template => 'main_page' }

  let(:foo_part) { Fabricate :news_item_part, :node => foo_page, :news_channel => '1', :region => 'content' }
  let(:bar_part) { Fabricate :news_item_part, :node => bar_page, :news_channel => '3', :region => 'content' }

  let(:baz_part) { Fabricate :news_item_part, :node => locale, :news_channel => '2', :region => 'content' }

  before { NewsItemPart.any_instance.stub(:index) }

  before { foo_part; bar_part; baz_part }

  let(:news) { { 'channel_ids' => [1, 2], 'slug' => 'ololo' } }

  context '#publish' do
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "#{foo_page.url}-/ololo") }
    before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'add', "#{bar_page.url}-/ololo") }
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "#{locale.url}-/ololo") }

    specify { subject.publish news }
  end

  context '#remove' do
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', "#{foo_page.url}-/ololo") }
    before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'remove', "#{bar_page.url}-/ololo") }
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', "#{locale.url}-/ololo") }

    specify { subject.remove news }
  end
end
