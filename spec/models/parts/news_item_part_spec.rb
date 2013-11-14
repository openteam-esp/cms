# encoding: utf-8

require 'spec_helper'

describe NewsItemPart do
  let(:part) { Fabricate :news_item_part }

  context "должна возвращять page_title для своей страницы" do
    before { NewsItemPart.any_instance.stub(:content).and_return({ 'title' => 'entry title' }) }
    before { part.node.update_attribute(:title, "Заголовок страницы") }

    specify { part.node.page_title.should == "entry title | Заголовок страницы" }
  end

  context "должна ставить title своего парта" do
    before { NewsItemPart.any_instance.stub(:content).and_return({ 'title' => 'entry title' }) }
    before { NewsItemPart.any_instance.stub(:response_status).and_return(200) }

    let(:expected_hash) {
      {
        'template' => 'news_item_part',
        'response_status' => 200,
        'type' => 'NewsItemPart',
        'part_title' => 'entry title',
        'content' => { 'title' => 'entry title' }
      }
    }

    specify { part.to_json.should ==  expected_hash }
  end

  context '#content' do
    subject { part }

    let(:response_hash) {
      { 'more_like_this' => [
          { 'slug' => 'ololo' },
          { 'slug' => 'pysh' }
        ]
      }
    }

    let(:expected_hash) {
      { 'more_like_this' => [
          { 'slug' => 'ololo', 'link' => '/ru/name/-/ololo' },
          { 'slug' => 'pysh', 'link' => '/ru/name/-/pysh' }
        ]
      }
    }

    before { part.stub(:response_status).and_return(200) }
    before { part.stub(:response_hash).and_return(response_hash) }
    before { part.stub(:slug).and_return('news_slug') }

    its(:content) { should == expected_hash }
  end

  describe 'receive news slugs from NEWS' do
    context '#news_slugs_for_page' do
      let(:page_json) {
        [
          { 'slug' => 'foo' },
          { 'slug' => 'bar' }
        ]
      }

      let(:requester) { double(Requester) }

      before { requester.stub(:response_hash).and_return(page_json) }
      before { Requester.should_receive(:new).with(part.news_list_url(1), 'application/json').and_return(requester) }

      specify { part.news_slugs_for_page(1).should == ['foo', 'bar'] }
    end

    context '#news_pages_count' do
      let(:response_headers) {
        { 'X-Total-Pages' => 3 }
      }

      let(:requester) { double(Requester) }

      before { requester.stub(:response_headers).and_return(response_headers) }
      before { Requester.should_receive(:new).with(part.news_list_url(1), 'application/json').and_return(requester) }

      specify { part.news_pages_count.should == 3 }

    end
  end

  describe 'should send to queue messages with' do
    let(:page) { Fabricate :page, :template => 'main_page' }
    let(:part) { Fabricate :news_item_part, :node => page, :region => 'content' }

    before { NewsItemPart.any_instance.stub(:news_pages_count).and_return(0) }
    before { NewsItemPart.any_instance.stub(:news_slugs_for_page).and_return([]) }

    describe 'add pages news slugs after update' do
      before { page.stub(:indexable_parts).and_return [part] }
      before { part.stub(:news_pages_count).and_return(2) }
      before { part.stub(:news_slugs_for_page).with(1).and_return(['ololo']) }
      before { part.stub(:news_slugs_for_page).with(2).and_return(['pish-pish']) }

      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'remove', page.url) }
      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'add', part.url_with_slug('ololo')) }
      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'add', part.url_with_slug('pish-pish')) }

      specify { part.update_attribute :title, "123234" }
    end

    describe 'with remove page_url after destroy' do
      before { part.should_not_receive(:index) }

      before { MessageMaker.should_receive(:make_message).once.with('esp.cms.searcher', 'remove', page.url) }

      specify { part.destroy }
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
#  title                                  :string(255)
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

