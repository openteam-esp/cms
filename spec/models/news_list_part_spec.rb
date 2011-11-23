# encoding: utf-8

require 'spec_helper'

describe NewsListPart do

  it { should belong_to :item_page }

  describe "должен правильно строить json" do
    before do
      @news_part = NewsListPart.create(:news_per_page => 2,
                                      :news_order_by => 'since_desc',
                                      :news_channel => 'news',
                                      :item_page => Fabricate(:page))

      request_hash = { 'x-total-pages' => ['3'], 'x-current-page' => ['1'] }
      @news_part.stub(:request).and_return(request_hash)
      request_hash.stub(:headers).and_return(request_hash)

      answer_from_news = {
        'entries' => [
          {'title' => 'title1', 'annotation' => 'annotation1', 'link' => 'link1'},
          {'title' => 'title2', 'annotation' => 'annotation2', 'link' => 'link2'}
      ]
      }
      @news_part.stub(:request_body).and_return(answer_from_news)
      @expected_hash = {
        'type' => 'NewsListPart',
        'content' => {
          'entries' => [
            {'title' => 'title1', 'annotation' => 'annotation1', 'link' => @news_part.item_page.route_without_site + '?parts_params[news_item][slug]=link1'},
            {'title' => 'title2', 'annotation' => 'annotation2', 'link' => @news_part.item_page.route_without_site + '?parts_params[news_item][slug]=link2'}
          ]
        }
      }
    end

    it "без пагинации" do
      @news_part.to_json.should == @expected_hash
    end

    it "с пагинацией" do
      @news_part.update_attribute(:news_paginated, true)
      @expected_hash['content'].merge!('pagination' => [
            { 'link' => '?parts_params[news_list][page]=1', 'current' => 'true' },
            { 'link' => '?parts_params[news_list][page]=2', 'current' => 'false' },
            { 'link' => '?parts_params[news_list][page]=3', 'current' => 'false' }
          ])
      @news_part.to_json.should == @expected_hash
    end

  end
end
# == Schema Information
#
# Table name: parts
#
#  id                       :integer         not null, primary key
#  html_content_id          :integer
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
#  blue_pages_expand        :boolean
#

