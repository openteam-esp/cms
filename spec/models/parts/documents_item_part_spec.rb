# encoding: utf-8

require 'spec_helper'

describe DocumentsItemPart do
  subject { Fabricate :documents_item_part }

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

