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
      let(:site_settings) { { 'part_templates' => { 'html_part' => 'template1|template2' } } }

      before do
        Page.any_instance.stub(:site_settings).and_return(site_settings)
      end

      it { part.available_templates.should == %w[html_part template1 template2] }
    end
  end

  describe 'indexed parts' do
    let(:page) { Fabricate :page, :template => 'main_page' }

    before { Page.any_instance.stub(:site_settings).and_return(YAML.load_file(Rails.root.join 'spec/fixtures/sites.yml').to_hash['sites']['www.tgr.ru']) }

    context 'indexable part' do
      let(:part) { Fabricate :html_part, :region => 'content', :node => page }

      it { part.should be_indexable }
    end

    context 'not indexable part' do
      let(:part) { Fabricate :html_part, :region => 'footer', :node => page }

      it { part.should_not be_indexable }
    end
  end

  context 'should send message to queue' do
    before { Page.any_instance.stub(:site_settings).and_return(YAML.load_file(Rails.root.join 'spec/fixtures/sites.yml').to_hash['sites']['www.tgr.ru']) }

    let(:page) { Fabricate :page, :template => 'main_page' }
    let(:indexable_part) { Fabricate :html_part, :region => 'content', :node => page }
    let(:not_indexable_part) { Fabricate :html_part, :region => 'footer', :node => page }

    describe '#update' do
      it 'in indexable region' do
        indexable_part.should_receive :index

        indexable_part.update_attribute :title, 'ololo'
      end

      it 'in not indexable region' do
        not_indexable_part.should_not_receive :index

        not_indexable_part.update_attribute :title, 'ololo'
      end
    end

    describe '#destroy' do
      it 'in indexable region' do
        indexable_part.should_receive :index

        indexable_part.destroy
      end

      it 'in not indexable region' do
        not_indexable_part.should_not_receive :index

        not_indexable_part.destroy
      end
    end

    describe '#index' do
      before { MessageMaker.should_receive(:make_message).with('esp.searcher.index', page.url) }

      specify { indexable_part.update_attribute :title, 'ololo' }
    end
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#  news_mlt_count              :integer
#  news_mlt_width              :integer
#  news_mlt_height             :integer
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#  text_info_path              :string(255)
#  news_event_entry            :string(255)
#  blue_pages_expand           :integer
#  documents_contexts          :string(255)
#  search_per_page             :integer
#

