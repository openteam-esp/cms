# encoding: utf-8

require 'spec_helper'

describe Page do
  subject { Fabricate :page, :template => 'main_page' }

  it { should have_many :parts }
  it { should validate_presence_of :template }
  it { should validate_presence_of :parent }
  it { Fabricate(:page).locale.slug.should == 'ru' }
  it { Fabricate(:page, :parent => Fabricate(:page)).locale.slug.should == 'ru' }
  it { Fabricate(:page).site.should be_is_root }
  it { Fabricate(:page, :parent => Fabricate(:page)).site.should be_is_root }

  describe 'navigation_group' do
    let(:page) { Fabricate(:page, :navigation_group => 'group') }
    let(:child_page) { page.pages.build }

    it { child_page.navigation_group.should == 'group' }
  end

  describe '#url' do
    its(:url) { should == 'http://example.com/ru/name/' }
  end

  describe '#slug' do
    let(:page_without_slug) { Fabricate(:page, :title => 'Страница', :slug => '') }
    let(:page_with_slug) { Fabricate(:page, :title => 'Страница', :slug => 'ololo') }
    let(:page_with_complex_slug) { Fabricate(:page, :title => 'Название страницы состоящее из нескольких слов', :slug => '') }

    it { page_without_slug.slug.should == 'stranitsa' }
    it { page_with_slug.slug.should == 'ololo' }
    it { page_with_complex_slug.slug.should == 'nazvanie-stranitsy-sostoyaschee-iz-neskolkih-slov' }
  end
end

# == Schema Information
#
# Table name: nodes
#
#  id                   :integer          not null, primary key
#  slug                 :string(255)
#  title                :text
#  ancestry             :string(255)
#  type                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  route                :text
#  template             :string(255)
#  client_url           :string(255)
#  in_navigation        :boolean
#  navigation_group     :string(255)
#  navigation_position  :integer
#  navigation_title     :text
#  ancestry_depth       :integer          default(0)
#  page_for_redirect_id :integer
#  weight               :string(255)
#

