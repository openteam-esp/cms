# encoding: utf-8

require 'spec_helper'

describe NodesController do
  render_views

  describe "GET show" do
    let(:page) { Fabricate(:page, :template => 'inner_page') }
    before do
      Page.any_instance.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][page.site.slug]['templates'])
    end
    let(:body) { JSON.parse(response.body).with_indifferent_access[:page] }

    describe "page properties in json" do
      before do
        get :show, :id => page.route, :format => :json
      end
      it { body[:link][0][:rel].should == page.title }
      it { body[:link][0][:href].should == page.route }
      it { body[:template].should == page.template }
    end

    it "HtmlPart content" do
      page.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][page.site.slug]['templates'])
      html_part = Fabricate(:html_part, :node => page, :region => 'content', :body => "any html text")
      get :show, :id => page.route, :format => :json
      body[:regions].keys.should == ['navigation', 'content']
      body[:regions][html_part.region]['content']['body'].should == html_part.body
    end

  end
end
