require 'spec_helper'

describe StorageSubscriber do
  subject { StorageSubscriber.new }

  let(:locale) { Fabricate :locale }

  let(:foo_page) { Fabricate :page, :parent => locale }
  let(:bar_page) { Fabricate :page, :parent => locale, :slug => 'bar' }
  let(:baz_page) { Fabricate :page, :parent => locale, :slug => 'baz' }

  let(:foo_html_part) { Fabricate :html_part, :node => foo_page, :html_info_path => '/path/to/file' }
  let(:bar_html_part) { Fabricate :html_part, :node => bar_page, :html_info_path => '/path/to/file' }

  let(:baz_html_part) { Fabricate :html_part, :node => baz_page, :html_info_path => '/path/to/file/baz' }

  let(:text_part) { Fabricate :text_part, :node => locale, :text_info_path => '/path/to/file' }

  before { foo_html_part; bar_html_part; baz_html_part; text_part }

  before { MessageMaker.stub(:make_message) }

  context '#update_content' do
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', foo_page.url) }
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', bar_page.url) }
    before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', locale.url) }

    specify { subject.update_content '/path/to/file' }
  end
end
