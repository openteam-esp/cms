# encoding: utf-8

require 'spec_helper'

describe Node do
  subject { Fabricate(:node) }

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

    it "после изменения слага сайта" do
      history
      root.update_attribute(:slug, 'st')
      root.reload.route.should == 'st'
      history.reload.route.should == 'st/ru/about/history'
    end

    it "после изменения родителя" do
      history
      about.parent = root
      about.save
      about.reload.route.should == 'site/about'
      history.reload.route.should == 'site/about/history'
    end
  end

  describe "должна" do
    let(:site) { Fabricate(:site) }
    let(:locale) { Fabricate(:locale, :template => 'main_page', :parent => site)}
    let(:page) { Fabricate(:page, :template => 'inner_page', :parent => locale)}

    it  { site.templates.should == ['main_page', 'inner_page'] }
    it  { locale.configurable_regions.should == ['navigation', 'content', 'footer'] }
    it  { locale.required_regions.should == ['navigation', 'content', 'footer'] }
    it  { page.required_regions.should == ['navigation', 'content'] }
    it  { page.configurable_regions.should == ['content'] }

    describe 'возвращать partы' do
      before do
        @page_content = Fabricate(:html_part, :node => page, :region => 'content')
        @locale_content = Fabricate(:html_part, :node => locale, :region => 'content')
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
      it { @first_page.reload.weight.should == '01/01/01' }

      it { @second_page.navigation_position.should == 2 }
      it { @second_page.weight.should == '01/01/02' }

      it { @third_page.navigation_position.should == 3 }
      it { @third_page.weight.should == '01/01/03' }

      it "when navigation_position_param => first" do
        @third_page.update_attribute(:navigation_position_param, 'first')
        @third_page.reload.navigation_position.should == 1
        @third_page.weight.should == '01/01/01'
        @first_page.reload.navigation_position.should == 2
        @first_page.weight.should == '01/01/02'
        @second_page.reload.navigation_position.should == 3
        @second_page.weight.should == '01/01/03'
      end

      it "when navigation_position_param => last" do
        @first_page.update_attribute(:navigation_position_param, 'last')
        locale.reload.child_ids.should == [@second_page.id, @third_page.id, @first_page.id]
      end

      it "after navigation_position_param => some_position" do
        @first_page.update_attribute(:navigation_position_param, '2')
        locale.reload.child_ids.should == [@second_page.id, @third_page.id, @first_page.id]
        @some_page = Fabricate(:page, :template => 'inner_page', :parent => locale, :slug => 'some_page', :navigation_position_param => '2')
        locale.reload.child_ids.should == [@second_page.id, @third_page.id, @some_page.id, @first_page.id]
        @first_page.update_attribute(:navigation_position_param, '1')
        locale.reload.child_ids.should == [@second_page.id, @first_page.id, @third_page.id, @some_page.id]
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

    context do 'weight'
      it { site.weight.should == '01' }
      it { en.weight.should == '01/01' }
      it { ru.weight.should == '01/02' }
      it { organy_vlasti.weight.should == '01/02/01' }
      it { governer.weight.should == '01/02/01/01' }
    end
  end

  describe 'контекст' do
    let(:site) { Fabricate(:site) }
    let(:locale) { Locale.create!(:parent => site, :slug => 'ru', :template => 'main_page') }
    let(:page) { Page.create!(:parent => locale, :template => 'inner_page', :title => 'страница') }
  end

  describe 'перенаправление на страницу' do
    let(:locale) { Fabricate :locale }

    let(:foo_page) { Fabricate :page, :slug => 'foo', :parent => locale }
    let(:bar_page) { Fabricate :page, :slug => 'bar', :parent => locale, :page_for_redirect => foo_page }

    let(:part) { Fabricate :navigation_part, :node => foo_page, :region => 'content', :from_node => locale }

    before { part }

    it { bar_page.to_json.should == foo_page.to_json }
  end

  describe 'индексируемые парты' do
    let(:locale) { Fabricate :locale }

    let(:foo_page) { Fabricate :page, :slug => 'foo', :parent => locale, :template => 'main_page' }
    let(:bar_page) { Fabricate :page, :slug => 'bar', :parent => locale, :template => 'inner_page' }

    it { foo_page.indexable_regions.should == ['content'] }
    it { bar_page.indexable_regions.should be_empty }
  end

  describe '#index messages' do
    let(:page) { Fabricate :page }
    let(:child_page) { Fabricate :page, :parent => page}

    describe '#destroy' do
      before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', page.url) }
      before { MessageMaker.should_not_receive(:make_message).with('esp.cms.searcher', 'remove', child_page.url) }

      specify { page.destroy }
    end

    describe '#update' do
      let(:part) { Fabricate :html_part, :node => page }
      before { page.stub(:indexable_parts).twice.and_return([part]) }

      describe 'title' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url).once }
        specify { page.update_attribute :title, 'новый заголовок'}
      end

      describe 'template' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url).once }
        specify { page.update_attribute :template, 'new_template'}
      end

      describe 'navigation_title' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url).once }
        specify { page.update_attribute :template, 'новый заголовок навигации'}
      end

      context 'slug or ancestry changed' do
        before { page.should_receive(:subtree).and_return([page, child_page]) }

        describe 'slug' do
          before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', "http://example.com/ru/name/").once }
          before { page.should_receive :index }
          before { child_page.should_receive :index }

          specify { page.update_attribute :slug, 'new_slug'}
        end

        describe 'ancestry' do
          let(:other_locale) { page.site.locales.create!(:slug => 'en', :template => 'main_page') }
          before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', "http://example.com/ru/name/").once }
          before { page.should_receive :index }
          before { child_page.should_receive :index }

          specify { page.update_attribute :parent_id, other_locale.id }
        end
      end
    end
  end

  describe '#reindex' do
    context 'making messages' do
      before { subject.should_receive :unindex }
      specify { subject.reindex }
    end

    context 'with indexable part' do
      let(:part) { Fabricate :html_part, :node => subject, :region => 'content' }
      before { subject.should_receive(:indexable_parts).twice.and_return([part]) }
      before { part.should_receive :index }
      specify { subject.reindex }
    end
  end
end

# == Schema Information
#
# Table name: nodes
#
#  id                    :integer          not null, primary key
#  slug                  :string(255)
#  title                 :text
#  ancestry              :string(255)
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  route                 :text
#  template              :string(255)
#  client_url            :string(255)
#  in_navigation         :boolean
#  navigation_group      :string(255)
#  navigation_position   :integer
#  navigation_title      :text
#  ancestry_depth        :integer          default(0)
#  page_for_redirect_id  :integer
#  weight                :string(255)
#  external_link         :text
#  alternative_title     :text
#  locale_association_id :integer
#
