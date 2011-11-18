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
    @part.node.page_route.should == "/ru/name?parts_params[news_item][slug]=entry_slug"
  end
end
