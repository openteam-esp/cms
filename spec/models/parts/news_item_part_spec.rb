# encoding: utf-8

require 'spec_helper'

describe NewsItemPart do
  let(:part) { Fabricate :news_item_part }

  before { part.node.update_attribute(:title, "Заголовок страницы") }

  context "должна возвращять page_title для своей страницы" do
    before { NewsItemPart.any_instance.stub(:content).and_return({ 'title' => 'entry title' }) }

    specify { part.node.page_title.should == "entry title | Заголовок страницы" }
  end

  context "должна ставить title своего парта" do
    before { NewsItemPart.any_instance.stub(:content).and_return({ 'title' => 'entry title' }) }
    before { NewsItemPart.any_instance.stub(:response_status).and_return(200) }

    let(:expected_hash) {
      {
        'template' => 'news_item_part',
        'response_status' => 200,
        'type' => 'NewsItemPart',
        'part_title' => 'entry title',
        'content' => { 'title' => 'entry title' }
      }
    }

    specify { part.to_json.should ==  expected_hash }
  end

  #context 'should send to queue messages with pages ulrs' do
    #let(:page) { Fabricate :page, :template => 'main_page' }
    #let(:part) { Fabricate :news_item_part, :node => page, :region => 'content' }

    #before { part }

    #it 'when update channel' do
     #MessageMaker.should_receive(:make_message).once.with('esp.searcher.index', page.url)
     #MessageMaker.should_receive(:make_message).once.with('esp.searcher.index', page.url)

     #part.update_attributes :news_channel => '1'
    #end
  #end
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

