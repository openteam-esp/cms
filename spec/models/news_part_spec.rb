# encoding: utf-8

require 'spec_helper'

describe NewsPart do
  it "плагин должен правильно строить json" do
    news_part = NewsPart.create(:news_per_page => 2,
                                :news_order_by => 'since_desc',
                                :news_channel => 'news')

    request_hash = { 'x-total-pages' => 3, 'x-current-page' => 1 }
    news_part.stub(:request).and_return(request_hash)
    request_hash.stub(:headers).and_return(request_hash)

    answer_from_news = {
      'entries' => [
        {'title' => 'title1', 'annotation' => 'annotation1', 'link' => 'link1'},
        {'title' => 'title2', 'annotation' => 'annotation2', 'link' => 'link2'}
      ]
    }
    news_part.stub(:request_body).and_return(answer_from_news)

    expected_hash = {
      'type' => 'NewsPart',
      'content' => {
        'entries' => [
          {'title' => 'title1', 'annotation' => 'annotation1', 'link' => 'link1'},
          {'title' => 'title2', 'annotation' => 'annotation2', 'link' => 'link2'}
        ],

        'pagination' => [
          { 'link' => 'page1', 'current' => 'true' },
          { 'link' => 'page2', 'current' => 'false' },
          { 'link' => 'page3', 'current' => 'false' }
        ]
      }
    }

    news_part.to_json.should == expected_hash
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
#

