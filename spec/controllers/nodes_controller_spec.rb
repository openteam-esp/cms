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

        data_hash = {
          'items' => [
            {'title' => 'title1', 'annotation' => 'annotation1', 'slug' => 'link1'},
            {'title' => 'title2', 'annotation' => 'annotation2', 'slug' => 'link2'}
          ]
        }

        NewsListPart.any_instance.stub(:response_status).and_return(200)
        NewsListPart.any_instance.stub(:data_hash).and_return(data_hash)

        get :show, :id => "#{news_list_part.node.route}", :parts_params => {"news_list"=>{"page"=>"2"}}, :format => :json
      end

      it { assigns(:node).should == page }
      it { assigns(:node).part_for('content').params.should == { 'page' => '2' }}
    end

    describe 'получение отдельного региона' do
      let(:expected_hash) { Hash.new('key' => 'value') }
      let(:parts_params) { Hash.new('parameter' => 'value') }

      before { Fabricate :navigation_part, :node => page, :region => 'content', :from_node => page.parent }
      before { NavigationPart.any_instance.stub(:to_json).and_return(expected_hash) }

      context 'существующий регион' do
        before { get :show, :id => page.route, :region => 'content', :format => 'json', :parts_params => { :navigation => parts_params } }

        specify { JSON.parse(response.body).should == expected_hash }
        specify { assigns(:part).params.should == parts_params }
      end

      context 'несуществующий регион' do
        before { get :show, :id => page.route, :region => 'unreal', :format => 'json' }

        specify { response.status.should == 404 }
      end
    end
  end
end
