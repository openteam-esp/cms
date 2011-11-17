
# encoding: utf-8

require 'spec_helper'

describe PartsController do

  let(:page) { Fabricate(:page, :template => 'inner_page', :slug => 'page') }

  before do
    Page.any_instance.stub(:configurable_regions).and_return({'content' => 'html', 'news' => 'news_list' })
  end

  describe "GET new content" do

    it "new html_part" do
      get :new, :node_id => page.id, :region => :content
      assigns(:part).class.should be HtmlPart
    end

    it "new news_list_part" do
      get :new, :node_id => page.id, :region => :news
      assigns(:part).class.should be NewsListPart
    end
  end
end
