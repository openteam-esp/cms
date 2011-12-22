# encoding: utf-8

require 'spec_helper'

describe BluePagesPart do
  def data_from_blue_pages
    hash = {
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

    hash.to_json
  end

  let(:json) { data_from_blue_pages }

  describe 'update links' do
    let(:blue_pages_part) { BluePagesPart.create(:item_page => Fabricate(:page)) }

    before do
      blue_pages_part.stub_chain(:request, :body).and_return(json)
    end

    it { blue_pages_part.content['items'][0]['link'].should == "#{blue_pages_part.item_page.route_without_site}?parts_params[blue_pages_item][link]=/categories/3/items/1" }
    it { blue_pages_part.content['subdivisions'][0]['items'][0]['link'].should == "#{blue_pages_part.item_page.route_without_site}?parts_params[blue_pages_item][link]=/categories/15/items/14"}
  end
end
# == Schema Information
#
# Table name: parts
#
#  id                       :integer         not null, primary key
#  created_at               :datetime
#  updated_at               :datetime
#  region                   :string(255)
#  type                     :string(255)
#  node_id                  :integer
#  navigation_end_level     :integer
#  navigation_from_id       :integer
#  navigation_default_level :integer
#  news_channel             :string(255)
#  news_order_by            :string(255)
#  news_until               :date
#  news_per_page            :integer
#  news_paginated           :boolean
#  news_item_page_id        :integer
#  blue_pages_category_id   :integer
#  appeal_section_slug      :string(255)
#  blue_pages_expand        :boolean
#  navigation_group         :string(255)
#  title                    :string(255)
#  html_info_path           :string(255)
#  blue_pages_item_page_id  :integer
#  documents_kind           :string(255)
#

