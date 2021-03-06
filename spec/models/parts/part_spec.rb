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
#  id                                     :integer          not null, primary key
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  region                                 :string(255)
#  type                                   :string(255)
#  node_id                                :integer
#  navigation_end_level                   :integer
#  navigation_from_id                     :integer
#  navigation_default_level               :integer
#  news_channel                           :string(255)
#  news_per_page                          :integer
#  news_paginated                         :boolean
#  news_item_page_id                      :integer
#  blue_pages_category_id                 :integer
#  appeal_section_slug                    :string(255)
#  navigation_group                       :string(255)
#  title                                  :text
#  html_info_path                         :text
#  blue_pages_item_page_id                :integer
#  documents_kind                         :string(255)
#  documents_item_page_id                 :integer
#  documents_paginated                    :boolean
#  documents_per_page                     :integer
#  youtube_resource_id                    :string(255)
#  youtube_item_page_id                   :integer
#  youtube_video_resource_id              :string(255)
#  youtube_resource_kind                  :string(255)
#  youtube_per_page                       :integer
#  youtube_paginated                      :boolean
#  youtube_video_resource_kind            :string(255)
#  news_height                            :integer
#  news_width                             :integer
#  news_mlt_count                         :integer
#  news_mlt_width                         :integer
#  news_mlt_height                        :integer
#  template                               :string(255)
#  youtube_video_with_related             :boolean
#  youtube_video_related_count            :integer
#  youtube_video_width                    :integer
#  youtube_video_height                   :integer
#  text_info_path                         :text
#  news_event_entry                       :string(255)
#  blue_pages_expand                      :integer
#  documents_contexts                     :string(255)
#  search_per_page                        :integer
#  organization_list_category_id          :integer
#  organization_list_per_page             :integer
#  organization_list_item_page_id         :integer
#  directory_presentation_id              :integer
#  directory_presentation_item_page_id    :integer
#  directory_presentation_photo_width     :integer
#  directory_presentation_photo_height    :integer
#  directory_presentation_photo_crop_kind :string(255)
#  directory_post_photo_width             :integer
#  directory_post_photo_height            :integer
#  directory_post_photo_crop_kind         :string(255)
#  directory_post_post_id                 :integer
#  gpo_project_list_chair_id              :integer
#  streams_degree                         :string(255)
#  provided_disciplines_subdepartment     :string(255)
#  news_mlt_number_of_months              :integer          default(1)
#

