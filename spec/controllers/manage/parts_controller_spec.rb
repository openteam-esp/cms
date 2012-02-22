
# encoding: utf-8

require 'spec_helper'

describe Manage::PartsController do

  let(:page) { Fabricate(:page, :template => 'inner_page', :slug => 'page') }

  before do
    Page.any_instance.stub(:configurable_regions).and_return(['content'])
  end

  describe "GET new content" do

    it "new html_part" do
      get :new, :node_id => page.id, :part => { :region => :content, :type => 'HtmlPart' }
      assigns(:part).class.should be HtmlPart
    end

    it "new news_list_part" do
      get :new, :node_id => page.id, :part => { :region => :content, :type => 'NewsListPart' }
      assigns(:part).class.should be NewsListPart
    end
  end
end
