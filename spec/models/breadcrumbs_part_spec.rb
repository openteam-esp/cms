# encoding: utf-8

require 'spec_helper'

describe BreadcrumbsPart do
  let(:site) { Fabricate(:site, :slug => 'www.tgr.ru', :title => 'site') }
  let(:locale) { Fabricate(:locale, :parent => site, :slug => 'ru', :title => 'ru') }
  let(:section) { Fabricate(:page, :parent => locale, :slug => 'section', :title => 'section') }
  let(:subsection) { Fabricate(:page, :parent => section, :slug => 'subsection', :title => 'subsection') }
  let(:page) { Fabricate(:page, :parent => subsection, :slug => 'page', :title => 'page') }

  it "должен строить крошки" do
    breadcrumbs_part = BreadcrumbsPart.create(:node => locale, :region => 'region')

    expected_hash = {
      'type' => 'BreadcrumbsPart',
      'content' => {
        'ru' => '/ru',
        'section' => '/ru/section',
        'subsection' => '/ru/section/subsection',
        'page' => '/ru/section/subsection/page'
      }
    }

    page.part_for('region', true).to_json.should == expected_hash
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
#  blue_pages_expand           :boolean
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  documents_context_id        :integer
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
#

