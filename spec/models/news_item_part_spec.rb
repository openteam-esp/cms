# encoding: utf-8

require 'spec_helper'

describe NewsItemPart do

  before do
    @part = Fabricate(:news_item_part)
  end

  it "должна возвращять page_tite для своей страницы" do
    NewsItemPart.any_instance.stub(:content).and_return( { 'title' => 'entry title' } )
    @part.node.page_title.should == "entry title"
  end

  it "должна возвращать route для своей страницы" do
    NewsItemPart.any_instance.stub(:params).and_return( { 'slug' => 'entry_slug' } )
    @part.node.page_route.should == "/ru/#{@part.node.slug}?parts_params[news_item][slug]=entry_slug"
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
#

