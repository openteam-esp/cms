require 'spec_helper'

describe BluePagesSubscriber do
  let(:locale) { Fabricate :locale }

  let(:page) { Fabricate :page, :parent => locale, :template => 'main_page' }

  before { part }

  def blue_pages_part(options={})
    BluePagesPart.create! :node => page,
                          :region => 'content',
                          :blue_pages_category_id => options[:category_id],
                          :blue_pages_expand => options[:level]
  end

  def do_add_category
    subject.add_category 4, 'parent_ids' => [3, 2, 1]
  end

  def do_remove_category
    subject.remove_category 4, 'parent_ids' => [3, 2, 1]
  end

  context 'category updates' do
    context 'level=0' do
      let(:part) { blue_pages_part :level => 0, :category_id => 4 }

      describe '#add_category' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url) }
        specify { do_add_category }
      end

      describe '#remove_category' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', page.url) }
        specify { do_remove_category }
      end
    end

    context 'level=1' do
      let(:part) { blue_pages_part :level => 1, :category_id => 3 }

      describe '#add_category' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url) }
        specify { do_add_category }
      end

      describe '#remove_category' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url) }
        specify { do_remove_category }
      end
    end

    context 'level=2' do
      let(:part) { blue_pages_part :level => 2, :category_id => 2 }

      describe '#add_category' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url) }
        specify { do_add_category }
      end

      describe '#remove_category' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url) }
        specify { do_remove_category }
      end
    end
  end

  context 'person updates' do
    def do_add_person
      subject.add_person(1, 'subdivision' => {'id' => 4, 'parent_ids' => [3, 2, 1]})
    end

    def do_remove_person
      subject.remove_person(1, 'subdivision' => {'id' => 4, 'parent_ids' => [3, 2, 1]})
    end

    context 'level=0' do
      let(:part) { blue_pages_part :level => 0, :category_id => 4 }
      let(:blue_pages_item_part) { Fabricate :blue_pages_item_part, :node => page }
      let(:item_page) { blue_pages_item_part.node }

      before { part.update_attributes :item_page => item_page }

      describe '#add_person' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', "#{item_page.url}-/categories/4/items/1/") }
        specify { do_add_person }
      end

      describe '#remove_person' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', "#{item_page.url}-/categories/4/items/1/") }
        specify { do_remove_person }
      end
    end

  end
end
