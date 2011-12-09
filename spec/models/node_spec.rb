# encoding: utf-8

require 'spec_helper'

describe Node do
  it { should allow_value('test_node123').for(:slug) }
  it { should allow_value('русские-буковки').for(:slug) }
  it { should_not allow_value('test/').for(:slug) }
  it { should normalize_attribute(:title).from('"English" "Русский"').to('“English” «Русский»') }
  it { should normalize_attribute(:title).from('  ru   ddd ').to('ru ddd') }
  it { should normalize_attribute(:title).from('ru').to('ru') }

  describe 'сохранение path' do
    let(:root) { Fabricate(:node, :parent => nil, :slug => 'site', :navigation_position => 2) }
    let(:ru) { Fabricate(:node, :parent => root, :slug => 'ru', :navigation_position => 1) }
    let(:about) { Fabricate(:node, :parent => ru, :slug => 'about', :navigation_position => 2) }
    let(:history) { Fabricate(:node, :parent => about, :slug => 'history', :navigation_position => 1) }

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

    describe 'проставлять нужную позицию' do
      before do
        @first_page = Fabricate(:page, :template => 'inner_page', :parent => locale, :slug => 'first_page')
        @second_page = Fabricate(:page, :template => 'inner_page', :parent => locale, :slug => 'second_page')
        @third_page = Fabricate(:page, :template => 'inner_page', :parent => locale, :slug => 'third_page')
      end

      it { @first_page.navigation_position.should == 1 }

      it { @second_page.navigation_position.should == 2 }

      it { @third_page.navigation_position.should == 3 }

      it "when navigation_position_param => first" do
        @third_page.update_attribute(:navigation_position_param, 'first')
        @third_page.reload.navigation_position.should == 1
        @first_page.reload.navigation_position.should == 2
        @second_page.reload.navigation_position.should == 3
      end

      it "when navigation_position_param => last" do
        @first_page.update_attribute(:navigation_position_param, 'last')
        locale.reload.child_ids.should == [@second_page.id, @third_page.id, @first_page.id]
      end

      it "after navigation_position_param => some_position" do
        @first_page.update_attribute(:navigation_position_param, '2')
        locale.reload.child_ids.should == [@second_page.id, @first_page.id, @third_page.id]
      end

    end

  end

  describe 'navigation_group' do
    let(:site) { Fabricate(:site) }
    let(:en) { Fabricate(:locale, :parent => site, :slug => 'en') }
    let(:ru) { Fabricate(:locale, :parent => en.site, :slug => 'ru') }
    let(:organy_vlasti) { Fabricate(:page, :parent => ru, :navigation_group => 'main') }
    let(:governer) { Fabricate(:page, :parent => organy_vlasti) }

    let(:store_data) { governer }

    before do
      store_data
    end

    it "должна сохранять значение navigation_group" do
      Node.where(:type => 'Locale').each_with_index do |locale, index|
        locale.update_attribute(:navigation_position, index)
      end

      organy_vlasti.reload.navigation_group.should == 'main'
    end

  end
end

# == Schema Information
#
# Table name: nodes
#
#  id                  :integer         not null, primary key
#  slug                :string(255)
#  title               :string(255)
#  ancestry            :string(255)
#  type                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  route               :text
#  template            :string(255)
#  client_url          :string(255)
#  in_navigation       :boolean
#  navigation_group    :string(255)
#  navigation_position :float
#  navigation_title    :string(255)
#  ancestry_depth      :integer         default(0)
#
