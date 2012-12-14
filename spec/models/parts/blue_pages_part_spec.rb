# encoding: utf-8

require 'spec_helper'

describe BluePagesPart do
  def department_page_title
    'Департамент по культуре'
  end

  describe 'update links' do
    let(:blue_pages_part) { BluePagesPart.create(:item_page => Fabricate(:page)) }

    it { blue_pages_part.content['items'][0]['link'].should == "#{blue_pages_part.item_page.route_without_site}/-/categories/3/items/1" }
    it { blue_pages_part.content['subdivisions'][0]['items'][0]['link'].should == "#{blue_pages_part.item_page.route_without_site}/-/categories/15/items/14"}
  end

  describe 'ссылки на подразделения' do
    let(:administration_page_title) { 'Администрация Томской области' }

    let(:locale)          { Fabricate :locale }
    let(:administration)  { Fabricate :page, :title => administration_page_title, :parent => locale, :slug => 'admin' }
    let(:department)      { Fabricate :page, :title => department_page_title, :parent => administration, :slug => 'department' }

    let(:blue_pages_part) { BluePagesPart.create(:node => administration, :item_page => Fabricate(:page, :parent => department)) }

    context 'find_node_by_title' do
      specify { blue_pages_part.administration_page.should == administration }
      specify { blue_pages_part.find_page_by_title(department_page_title).should == department }
    end

    context 'subdivision paths' do
      specify { blue_pages_part.content['subdivisions'].last['path'].should == '/ru/admin/department' }
    end
  end

  describe '#save' do
    let(:page) { Fabricate :page, :template => 'main_page' }
    let(:blue_pages_part) { Fabricate :blue_pages_part, :node => page, :blue_pages_expand => options[:level], :blue_pages_category_id => options[:category_id], :item_page => page, :region => 'content' }

    context 'level=0' do
      let(:options) { {level: 0, category_id: 4} }
      context 'new_record' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', 'http://example.com/ru/name/-/categories/3/items/1/') }
        specify { blue_pages_part }
      end

      context 'persisted' do
        context 'updated item_page or category' do
          before { blue_pages_part }
          before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', 'http://example.com/ru/name/') }
          before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', 'http://example.com/ru/-/categories/3/items/1/') }
          specify { blue_pages_part.update_attribute :item_page, page.locale }
        end

        context '#destroy' do
          before { blue_pages_part }
          before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'remove', 'http://example.com/ru/name/') }
          specify { blue_pages_part.destroy }
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: parts
#
#  appeal_section_slug            :string(255)
#  blue_pages_category_id         :integer
#  blue_pages_expand              :integer
#  blue_pages_item_page_id        :integer
#  created_at                     :datetime         not null
#  documents_contexts             :string(255)
#  documents_item_page_id         :integer
#  documents_kind                 :string(255)
#  documents_paginated            :boolean
#  documents_per_page             :integer
#  html_info_path                 :text
#  id                             :integer          not null, primary key
#  navigation_default_level       :integer
#  navigation_end_level           :integer
#  navigation_from_id             :integer
#  navigation_group               :string(255)
#  news_channel                   :string(255)
#  news_event_entry               :string(255)
#  news_height                    :integer
#  news_item_page_id              :integer
#  news_mlt_count                 :integer
#  news_mlt_height                :integer
#  news_mlt_width                 :integer
#  news_paginated                 :boolean
#  news_per_page                  :integer
#  news_width                     :integer
#  node_id                        :integer
#  organization_list_category_id  :integer
#  organization_list_item_page_id :integer
#  organization_list_per_page     :integer
#  region                         :string(255)
#  search_per_page                :integer
#  template                       :string(255)
#  text_info_path                 :text
#  title                          :string(255)
#  type                           :string(255)
#  updated_at                     :datetime         not null
#  youtube_item_page_id           :integer
#  youtube_paginated              :boolean
#  youtube_per_page               :integer
#  youtube_resource_id            :string(255)
#  youtube_resource_kind          :string(255)
#  youtube_video_height           :integer
#  youtube_video_related_count    :integer
#  youtube_video_resource_id      :string(255)
#  youtube_video_resource_kind    :string(255)
#  youtube_video_width            :integer
#  youtube_video_with_related     :boolean
#

