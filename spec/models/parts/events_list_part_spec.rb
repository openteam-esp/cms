# encoding: utf-8

require 'spec_helper'

describe EventsListPart do
  it { should belong_to :item_page }

  it { should validate_presence_of :news_event_entry }

  let(:page) { Fabricate :page }
  let(:part) { EventsListPart.create(:news_per_page => 2,
                                     :news_channel => '13',
                                     :news_event_entry => 'current',
                                     :item_page => page,
                                     :title => 'Новости',
                                     :node => page.locale,
                                     :news_width => '100',
                                     :news_height => '100') }

  describe 'should build right query string' do
    let(:common_params) {
      q = "#{Settings['news.url']}/entries?utf8=%E2%9C%93"
      q << "&type=events"
      q << "&entry_search[channel_ids][]=13"
      q << "&per_page=#{part.news_per_page}"
    }

    let(:image_params) {
      "&entries_params[width]=100&entries_params[height]=100"
    }

    describe 'for first page' do
      let(:query_string) { common_params << "&page=1&events_type=current" << image_params }

      before { part.stub(:params).and_return({}) }

      specify { part.url_for_request.should == query_string }
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

