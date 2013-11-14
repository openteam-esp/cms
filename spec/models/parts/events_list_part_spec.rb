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

  before { part.stub(:response_headers).and_return('X-Min-Date' => '2012-01-01', 'X-Max-Date' => '2012-05-02') }

  describe 'should build right query string' do
    let(:common_params) {
      q = "#{Settings['news.url']}/entries?utf8=%E2%9C%93"
      q << "&entry_search[entry_type]=events"
      q << "&entry_search[channel_ids][]=13"
      q << "&per_page=#{part.news_per_page}"
    }

    let(:image_params) {
      "&entries_params[width]=100&entries_params[height]=100"
    }

    describe 'for first page' do
      let(:query_string) { common_params << "&page=1&entry_search[events_type]=current" << image_params }

      before { part.stub(:params).and_return({}) }

      specify { part.url_for_request.should == query_string }
    end
  end

  describe 'should build json' do
    let(:response_hash) {
      [
        {'title' => 'title1', 'annotation' => 'annotation1', 'slug' => 'link1'},
        {'title' => 'title2', 'annotation' => 'annotation2', 'slug' => 'link2'}
      ]
    }

    let(:expected_hash) {
      {
        'template' => 'events_list_part',
        'response_status' => 200,
        'type' => 'EventsListPart',
        'part_title' => 'Новости',
        'archive_dates' => { 'min_date' => '2012-01-01', 'max_date' => '2012-05-02' },
        'content' => {
          'items' => [
            {'title' => 'title1', 'annotation' => 'annotation1', 'slug' => 'link1', 'link' => part.item_page.route_without_site + '/-/link1'},
            {'title' => 'title2', 'annotation' => 'annotation2', 'slug' => 'link2', 'link' => part.item_page.route_without_site + '/-/link2'}
          ],

          'collection_link' => '/ru',
          'title' => 'Новости',
          'rss_link' => "#{Settings['news.url']}/channels/13/entries.rss?path_param=http://example.com/ru/name"
        }
      }
    }

    before { part.stub(:response_hash).and_return(response_hash) }
    before { part.stub(:response_status).and_return(200) }


    describe 'with pagination' do
      before { part.update_attribute(:news_paginated, true) }

      before { part.stub(:total_count).and_return(100) }
      before { part.stub(:total_pages).and_return(10) }
      before { part.stub(:per_page).and_return(10) }
      before { part.stub(:current_page).and_return(2) }

      before {
        expected_hash['content'].merge!('pagination' => {
          'total_count' => 100,
          'current_page' => 2,
          'per_page' => 2,
          'param_name' => 'parts_params[events_list][page]'
        })
      }

      specify { part.to_json.should == expected_hash }
    end
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                                     :integer          not null, primary key
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  region                                 :string(255)
#  type                                   :string(255)
#  node_id                                :integer
#  navigation_end_level                   :integer
#  navigation_from_id                     :integer
#  navigation_default_level               :integer
#  news_channel                           :string(255)
#  news_per_page                          :integer
#  news_paginated                         :boolean
#  news_item_page_id                      :integer
#  blue_pages_category_id                 :integer
#  appeal_section_slug                    :string(255)
#  navigation_group                       :string(255)
#  title                                  :string(255)
#  html_info_path                         :text
#  blue_pages_item_page_id                :integer
#  documents_kind                         :string(255)
#  documents_item_page_id                 :integer
#  documents_paginated                    :boolean
#  documents_per_page                     :integer
#  youtube_resource_id                    :string(255)
#  youtube_item_page_id                   :integer
#  youtube_video_resource_id              :string(255)
#  youtube_resource_kind                  :string(255)
#  youtube_per_page                       :integer
#  youtube_paginated                      :boolean
#  youtube_video_resource_kind            :string(255)
#  news_height                            :integer
#  news_width                             :integer
#  news_mlt_count                         :integer
#  news_mlt_width                         :integer
#  news_mlt_height                        :integer
#  template                               :string(255)
#  youtube_video_with_related             :boolean
#  youtube_video_related_count            :integer
#  youtube_video_width                    :integer
#  youtube_video_height                   :integer
#  text_info_path                         :text
#  news_event_entry                       :string(255)
#  blue_pages_expand                      :integer
#  documents_contexts                     :string(255)
#  search_per_page                        :integer
#  organization_list_category_id          :integer
#  organization_list_per_page             :integer
#  organization_list_item_page_id         :integer
#  directory_presentation_id              :integer
#  directory_presentation_item_page_id    :integer
#  directory_presentation_photo_width     :integer
#  directory_presentation_photo_height    :integer
#  directory_presentation_photo_crop_kind :string(255)
#  directory_post_photo_width             :integer
#  directory_post_photo_height            :integer
#  directory_post_photo_crop_kind         :string(255)
#  directory_post_post_id                 :integer
#  gpo_project_list_chair_id              :integer
#  streams_degree                         :string(255)
#  provided_disciplines_subdepartment     :string(255)
#  news_mlt_number_of_months              :integer          default(1)
#

