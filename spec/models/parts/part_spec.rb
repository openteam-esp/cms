require 'spec_helper'

describe Part do
  it { should belong_to :node }
  it { should validate_presence_of :node }
  it { should validate_presence_of :region }
  it { should validate_presence_of :template }

  describe 'template' do
    let(:part) { Fabricate(:html_part) }

    describe 'default' do
      it { part.template.should == 'html_part' }
    end

    describe 'available' do
      let(:part_templates) { { 'part_templates' => { 'html_part' => 'template1|template2' } } }

      before do
        Page.any_instance.stub(:site_settings).and_return(sites_settings['sites']['www.tgr.ru'].merge!(part_templates))
      end

      it { part.available_templates.should == %w[html_part template1 template2] }
    end
  end

  describe 'indexed parts' do
    let(:page) { Fabricate :page, :template => 'main_page' }

    context 'indexable part' do
      let(:part) { Fabricate :html_part, :region => 'content', :node => page }

      it { part.should be_indexable }
    end

    context 'not indexable part' do
      let(:part) { Fabricate :html_part, :region => 'footer', :node => page }

      it { part.should_not be_indexable }
    end
  end

  describe 'indexing nodes' do
    let(:page) { Fabricate :page, :template => 'main_page' }

    context 'indexable' do
      subject{ Fabricate :html_part, :region => 'content', :node => page }

      context '#index' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.searcher', 'add', page.url) }
        specify { subject }
      end

      context 'persisted' do
        before { subject }

        describe '#save' do
          before { page.should_receive(:indexable_parts).twice.and_return([subject]) }
          before { subject.should_receive :index }
          specify { subject.update_attribute :title, 'ololo' }
        end

        describe '#destroy' do
          before { page.should_receive :reindex }
          specify { subject.destroy }
        end
      end
    end

    context 'unindexable' do
      subject { Fabricate :html_part, :region => 'footer', :node => page }
      before { subject.should_not_receive :node_index }

      describe '#save' do
        specify { subject.update_attribute :title, 'ololo' }
      end

      describe '#destroy' do
        specify { subject.destroy }
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

