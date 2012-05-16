# encoding: utf-8

require 'spec_helper'

describe DocumentsItemPart do
  it { should normalize_attribute(:documents_contexts).from(['', '', '1', '2']).to([1, 2]) }

  describe '#url_for_request' do
    before { DocumentsItemPart.any_instance.stub(:paper_id).and_return('1') }

    describe 'for documents part' do
      let(:part) { Fabricate :documents_item_part, :documents_kind => 'documents', :documents_contexts => [2, 3] }

      specify { part.url_for_request.should == "#{Settings['documents.url']}/documents/1?context_ids[]=2&context_ids[]=3" }
    end

    describe 'for projects part' do
      let(:part) { Fabricate :documents_item_part, :documents_kind => 'projects', :documents_contexts => [2, 3] }

      specify { part.url_for_request.should == "#{Settings['documents.url']}/projects/1?context_ids[]=2&context_ids[]=3" }
    end
  end

  describe 'receive papers from DOCUMENTS' do
    let(:part) { Fabricate :documents_item_part, :documents_kind => 'documents', :documents_contexts => [2, 3] }

    context '#papers_pages_count' do
      let(:response_headers) {
        { 'X-Total-Pages' => 3 }
      }

      let(:requester) { double(Requester) }

      before { requester.stub(:response_headers).and_return(response_headers) }
      before { Requester.should_receive(:new).with(part.papers_list_url(1), 'application/json').and_return(requester) }

      specify { part.papers_pages_count.should == 3 }
    end

    context '#paper_ids_for_page' do
      let(:page_json) {
        [
          { 'id' => '1' },
          { 'id' => '2' }
        ]
      }

      let(:requester) { double(Requester) }

      before { requester.stub(:response_hash).and_return(page_json) }
      before { Requester.should_receive(:new).with(part.papers_list_url(1), 'application/json').and_return(requester) }

      specify { part.paper_ids_for_page(1).should == ['1', '2'] }
    end
  end

  describe 'should send to queue messages with' do
    let(:page) { Fabricate :page, :template => 'main_page' }
    let(:part) { Fabricate :documents_item_part, :documents_kind => 'documents', :documents_contexts => [2, 3], :region => 'content', :node => page }

    before { DocumentsItemPart.any_instance.stub(:papers_pages_count).and_return(0) }
    before { DocumentsItemPart.any_instance.stub(:paper_ids_for_page).and_return([]) }

    describe 'add pages papers ids after update' do
      before { page.should_receive(:indexable_parts).twice.and_return([part]) }
      before { part.stub(:papers_pages_count).and_return(2) }
      before { part.stub(:paper_ids_for_page).with(1).and_return(['222', '111']) }
      before { part.stub(:paper_ids_for_page).with(2).and_return(['333']) }

      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'add', part.paper_url('222')) }
      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'add', part.paper_url('111')) }
      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'add', part.paper_url('333')) }

      specify { part.update_attribute :title, "123234" }
    end

    describe 'remove page_url after destroy' do
      before { part.should_not_receive(:index) }

      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'remove', page.url) }

      specify { part.destroy }
    end
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#  news_mlt_count              :integer
#  news_mlt_width              :integer
#  news_mlt_height             :integer
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#  text_info_path              :string(255)
#  news_event_entry            :string(255)
#  blue_pages_expand           :integer
#  documents_contexts          :string(255)
#

