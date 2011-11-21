# encoding: utf-8

require 'spec_helper'

describe Node do
  it { should validate_presence_of :slug }
  it { should allow_value('test_node123').for(:slug) }
  it { should allow_value('русские-буковки').for(:slug) }
  it { should_not allow_value('test/').for(:slug) }
  it { should normalize_attribute(:title).from('"English" "Русский"').to('“English” «Русский»') }
  it { should normalize_attribute(:title).from('  ru   ddd ').to('ru ddd') }
  it { should normalize_attribute(:title).from('ru').to('ru') }

  describe 'сохранение path' do
    let(:root) { Fabricate(:node, :parent => nil, :slug => 'site') }
    let(:ru) { Fabricate(:node, :parent => root, :slug => 'ru') }
    let(:about) { Fabricate(:node, :parent => ru, :slug => 'about') }
    let(:history) { Fabricate(:node, :parent => about, :slug => 'history') }

    it { root.route.should == 'site' }
    it { ru.route.should == 'site/ru' }
    it { about.route.should == 'site/ru/about' }
    it { history.route.should == 'site/ru/about/history' }
  end

  describe "должна" do
    let(:site) { Fabricate(:site) }
    let(:locale) { Fabricate(:locale, :template => 'main_page', :parent => site)}
    let(:page) { Fabricate(:page, :template => 'inner_page', :parent => locale)}
    before do
      Site.any_instance.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][site.slug]['templates'])
      Locale.any_instance.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][site.slug]['templates'])
      Page.any_instance.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][site.slug]['templates'])
    end
    it  { site.templates.should == ['main_page', 'inner_page'] }
    it  { locale.configurable_regions.should == ['navigation', 'content', 'footer'] }
    it  { locale.required_regions.should == ['navigation', 'content', 'footer'] }
    it  { page.required_regions.should == ['navigation', 'content'] }
    it  { page.configurable_regions.should == ['content'] }

    describe 'возвращать partы' do
      before do
        @page_content = Fabricate(:html_part, :body => "text", :node => page, :region => 'content')
        @locale_content = Fabricate(:html_part, :body => "text", :node => locale, :region => 'content')
        @navigation_part = Fabricate(:navigation_part,
                                     :node => locale,
                                     :region => 'navigation',
                                     :from_node => locale,
                                     :navigation_end_level => 1)
      end
      it { page.part_for('navigation', true).should == @navigation_part }
      it { page.part_for('navigation').should be nil }
      it { page.part_for('content', true).should == @page_content }
    end
  end
end

# == Schema Information
#
# Table name: nodes
#
#  id            :integer         not null, primary key
#  slug          :string(255)
#  title         :string(255)
#  ancestry      :string(255)
#  type          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  route         :text
#  template      :string(255)
#  client_url    :string(255)
#  in_navigation :boolean
#

