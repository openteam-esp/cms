# encoding: utf-8

require 'spec_helper'

describe NodesController do
  render_views

  describe "GET show" do
    let(:page) { Fabricate(:page, :template => 'inner_page') }
    let(:body) { JSON.parse(response.body).with_indifferent_access[:page] }

    before do
      Page.any_instance.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][page.site.slug]['templates'])
    end

    describe "page properties in json" do
      before do
        get :show, :id => page.route, :format => :json
      end
      it { body[:title].should == page.title }
      it { body[:template].should == page.template }
    end

    it "HtmlPart content" do
      page.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][page.site.slug]['templates'])
      html_part = Fabricate(:html_part, :node => page, :region => 'content')

      HtmlPart.any_instance.stub(:body).and_return('some body')

      get :show, :id => page.route, :format => :json

      body[:regions].keys.should == ['navigation', 'content']
      body[:regions][html_part.region]['content']['body'].should == html_part.body
    end

    describe 'routes' do
      render_views false

      let(:page) { Fabricate(:page, :template => 'inner_page', :slug => 'page') }
      let(:view_page) { Fabricate(:page, :template => 'inner_page', :slug => 'view_page', :parent => page) }

      let(:news_list_part) { Fabricate(:news_list_part, :node => page, :region => 'content', :item_page => view_page) }

      before do
        page.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][page.site.slug]['templates'])

        request_body_results = {
          'items' => [
            {'title' => 'title1', 'annotation' => 'annotation1', 'slug' => 'link1'},
            {'title' => 'title2', 'annotation' => 'annotation2', 'slug' => 'link2'}
          ]
        }

        NewsListPart.any_instance.stub(:request_body).and_return(request_body_results)

        get :show, :id => "#{news_list_part.node.route}", :parts_params => {"news_list"=>{"page"=>"2"}}, :format => :json
      end

      it { assigns(:node).should == page }
      it { assigns(:node).part_for('content').params.should == { 'page' => '2' }}
    end
  end
end
