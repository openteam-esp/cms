# encoding: utf-8

require 'spec_helper'

describe TextPart do

  before do
    @part = Fabricate(:text_part)
    @part.node.update_attribute(:title, "Заголовок страницы")
  end

  it "должна возвращять part_title для своей страницы" do
    TextPart.any_instance.stub(:content).and_return( { 'body' => 'text content' } )
    TextPart.any_instance.stub(:title).and_return('Заголовок парта')

    @part.node.page_title.should == "Заголовок страницы"
  end

  it "должна ставить part_title" do
    TextPart.any_instance.stub(:content).and_return( { 'body' => '<script type="text/javascript">alert("text content");</script>' } )
    TextPart.any_instance.stub(:title).and_return('Заголовок парта')
    TextPart.any_instance.stub(:response_status).and_return(200)

    @expected_hash = {
      'template' => 'text_part',
      'response_status' => 200,
      'type' => 'TextPart',
      'part_title' => 'Заголовок парта',
      'content' => { 'body' => '<script type="text/javascript">alert("text content");</script>' }
    }

    @part.to_json.should ==  @expected_hash
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

