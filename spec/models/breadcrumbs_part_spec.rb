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
        'ru' => '/ru/',
        'section' => '/ru/section/',
        'subsection' => '/ru/section/subsection/',
        'page' => '/ru/section/subsection/page/'
      }
    }

    page.part_for('region', true).to_json.should == expected_hash
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                       :integer         not null, primary key
#  created_at               :datetime
#  updated_at               :datetime
#  region                   :string(255)
#  type                     :string(255)
#  node_id                  :integer
#  navigation_end_level     :integer
#  navigation_from_id       :integer
#  navigation_default_level :integer
#  news_channel             :string(255)
#  news_order_by            :string(255)
#  news_until               :date
#  news_per_page            :integer
#  news_paginated           :boolean
#  news_item_page_id        :integer
#  blue_pages_category_id   :integer
#  appeal_section_slug      :string(255)
#  blue_pages_expand        :boolean
#  navigation_group         :string(255)
#  title                    :string(255)
#  html_info_path           :string(255)
#  blue_pages_item_page_id  :integer
#

