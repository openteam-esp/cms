# encoding: utf-8

require 'spec_helper'

describe BluePagesPart do
  def data_from_blue_pages
    {
      'title' => 'Губернатор',
      'address' => '634050, Томская область, г. Томск, пл. Ленина, 6',
      'phones' => 'Тел.: (3822) 510-813, (3822) 510-505',
      'items' => [
        {
          'person' => 'Кресс Виктор Мельхиорович',
          'title' => 'Губернатор',
          'address' => '',
          'link' => '/categories/3/items/1',
          'phones' => 'Тел.: (3822) 510-813, (3822) 510-505'
        }
      ],
      'subdivisions' => [
        {
          'title' => 'Заместитель губернатора Томской области по особо важным проектам',
          'address' => '634050, Томская область, г. Томск, пл. Ленина, 6',
          'phones' => 'Тел.: (3822) 511-142',
          'items' => [
            {
              'person' => 'Точилин Сергей Борисович',
              'title' => 'Заместитель губернатора Томской области по особо важным проектам',
              'address' => '',
              'link' => '/categories/15/items/14',
              'phones' => 'Тел.: (3822) 511-142'
            }
          ]
        }
      ]
    }
  end

  describe 'update links' do
    let(:blue_pages_part) { BluePagesPart.create(:item_page => Fabricate(:page)) }

    before do
      blue_pages_part.stub(:response_hash).and_return(data_from_blue_pages)
      blue_pages_part.stub(:respense_status).and_return(200)
    end

    it { blue_pages_part.content['items'][0]['link'].should == "#{blue_pages_part.item_page.route_without_site}/-/categories/3/items/1" }
    it { blue_pages_part.content['subdivisions'][0]['items'][0]['link'].should == "#{blue_pages_part.item_page.route_without_site}/-/categories/15/items/14"}
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
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#  text_info_path              :string(255)
#  news_event_entry            :string(255)
#  blue_pages_expand           :integer
#

