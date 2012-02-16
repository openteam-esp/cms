# encoding: utf-8

require 'spec_helper'

describe NewsListPart do

  it { should belong_to :item_page }

  describe "должен правильно строить json" do
    before do
      @news_part = NewsListPart.create(:news_per_page => 2,
                                      :news_order_by => 'since_desc',
                                      :news_channel => 'news',
                                      :item_page => Fabricate(:page),
                                      :title => 'Новости')

      response_hash = [
        {'title' => 'title1', 'annotation' => 'annotation1', 'slug' => 'link1'},
        {'title' => 'title2', 'annotation' => 'annotation2', 'slug' => 'link2'}
      ]

      @news_part.stub(:response_hash).and_return(response_hash)
      @news_part.stub(:response_status).and_return(200)

      @expected_hash = {
        'response_status' => 200,
        'type' => 'NewsListPart',
        'part_title' => 'Новости',
        'content' => {
          'items' => [
            {'title' => 'title1', 'annotation' => 'annotation1', 'slug' => 'link1', 'link' => @news_part.item_page.route_without_site + '?parts_params[news_item][slug]=link1'},
            {'title' => 'title2', 'annotation' => 'annotation2', 'slug' => 'link2', 'link' => @news_part.item_page.route_without_site + '?parts_params[news_item][slug]=link2'}
          ],

          'title' => 'Новости'
        }
      }
    end

    it "без пагинации" do
      @news_part.to_json.should == @expected_hash
    end

    it "с пагинацией" do
      @news_part.update_attribute(:news_paginated, true)

      @news_part.stub(:total_count).and_return(100)
      @news_part.stub(:total_pages).and_return(10)
      @news_part.stub(:per_page).and_return(10)
      @news_part.stub(:current_page).and_return(2)

      @expected_hash['content'].merge!('pagination' => {
        'total_count' => 100,
        'current_page' => 2,
        'per_page' => 2,
        'param_name' => 'parts_params[news_list][page]'
      })

      @news_part.to_json.should == @expected_hash
    end

  end
end
# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_order_by               :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  blue_pages_expand           :boolean
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  documents_context_id        :integer
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
#

