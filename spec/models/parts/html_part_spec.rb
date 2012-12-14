# encoding: utf-8

require 'spec_helper'

describe HtmlPart do

  context 'созданная' do
    subject do
      part = Fabricate(:html_part)
      part.node.update_attribute(:title, "Заголовок страницы")
      part
    end

    before { HtmlPart.any_instance.stub(:content).and_return( { 'body' => 'html content' } ) }
    before { HtmlPart.any_instance.stub(:title).and_return('Заголовок парта') }

    describe "должна возвращять part_title для своей страницы" do
      its('node.page_title') { should == "Заголовок страницы" }
    end

    describe "должна ставить part_title" do
      before { HtmlPart.any_instance.stub(:response_status).and_return(200) }

      let(:expected_hash) do
        {
          'template' => 'html_part',
          'response_status' => 200,
          'type' => 'HtmlPart',
          'part_title' => 'Заголовок парта',
          'content' => { 'body' => 'html content' }
        }
      end

      its(:to_json) { should == expected_hash  }
    end
  end

  context 'sending messages to storage queue' do
    let(:node) { Fabricate :page }
    subject { Fabricate :html_part, :node => node, :html_info_path => '/storage/path/to/file.xhtml' }
    alias :create_subject :subject
    describe '.create' do
      before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'lock_by_path', {:external_url => "#{node.url}#region", :entry_path => '/storage/path/to/file.xhtml'}) }
      specify { create_subject }
    end
    describe '#update' do
      before { create_subject }
      context 'html_info_path updated' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'unlock_by_path', {:external_url => "#{node.url}#region", :entry_path => '/storage/path/to/file.xhtml'}) }
        before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'lock_by_path', {:external_url => "#{node.url}#region", :entry_path => '/new/path/to/file.xhtml'}) }
        specify { subject.update_attribute :html_info_path, '/new/path/to/file.xhtml' }
      end
      context 'region updated' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'unlock_by_path', {:external_url => "#{node.url}#region", :entry_path => '/storage/path/to/file.xhtml'}) }
        before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'lock_by_path', {:external_url => "#{node.url}#new_region", :entry_path => '/storage/path/to/file.xhtml'}) }
        specify { subject.update_attribute :region, 'new_region' }
      end
    end
    describe '#destroy' do
      before { create_subject }
      before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'unlock_by_path', {:external_url => "#{node.url}#region", :entry_path => '/storage/path/to/file.xhtml'}) }
      specify { subject.destroy }
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

