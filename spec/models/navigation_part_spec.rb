# encoding: utf-8

require 'spec_helper'

describe NavigationPart do
  it { should belong_to :from_node }
  it { should validate_presence_of :from_node }
  it { should validate_presence_of :navigation_end_level }

  describe 'json' do
    let(:site) { Fabricate(:site, :slug => 'www.tgr.ru', :title => 'site') }
      let(:locale) { Fabricate(:locale, :parent => site, :slug => 'ru', :title => 'ru') }
        let(:section1) { Fabricate(:page, :parent => locale, :slug => 'section1', :title => 'section1') }
          let(:subsection11) { Fabricate(:page, :parent => section1, :slug => 'subsection11', :title => 'subsection11') }
            let(:page111) { Fabricate(:page, :parent => subsection11, :slug => 'page111', :title => 'page111') }
            let(:page112) { Fabricate(:page, :parent => subsection11, :slug => 'page112', :title => 'page112') }
            let(:page113) { Fabricate(:page, :parent => subsection11, :slug => 'page113', :title => 'page113', :in_navigation => false) }
          let(:page11) { Fabricate(:page, :parent => section1, :slug => 'page11', :title => 'page11') }
        let(:section2) { Fabricate(:page, :parent => locale, :slug => 'section2', :title => 'section2') }
        let(:section3) { Fabricate(:page, :parent => locale, :slug => 'section3', :title => 'section3') }
          let(:subsection31) { Fabricate(:page, :parent => section3, :slug => 'subsection31', :title => 'subsection31') }
            let(:page311) { Fabricate(:page, :parent => subsection31, :slug => 'page311', :title => 'page311') }
          let(:subsection32) { Fabricate(:page, :parent => section3, :slug => 'subsection32', :title => 'subsection32') }
            let(:page321) { Fabricate(:page, :parent => subsection32, :slug => 'page321', :title => 'page321') }
          let(:subsection33) { Fabricate(:page, :parent => section3, :slug => 'subsection33', :title => 'subsection33') }
            let(:page331) { Fabricate(:page, :parent => subsection33, :slug => 'page331', :title => 'page331') }
        let(:page4) { Fabricate(:page, :parent => locale, :slug => 'page4', :title => 'page4')}
        let(:page5) { Fabricate(:page, :parent => locale, :slug => 'page5', :title => 'page5')}
        let(:page_not_in_navigation) { Fabricate(:page, :parent => locale, :slug => 'not_in_navigation', :title => 'not in navigation', :in_navigation => false)}

        let(:build_site) { page111; page112; page113; page11; section2; page311; page321; page331; page4; page5; page_not_in_navigation }

    before do

      build_site
    end

    it 'меню первого уровня для локали' do
      navigation_part = Fabricate(:navigation_part,
                                  :node => locale,
                                  :region => 'region',
                                  :from_node => locale,
                                  :navigation_default_level => 1)
      expected_hash = {
        'type' => 'NavigationPart',
        'content' => { 'ru' => {
                              'title' => 'ru',
                              'path' => '/ru/',
                              'children' => {
                                        'section1' => { 'title' => 'section1', 'path' => '/ru/section1/' },
                                        'section2' => { 'title' => 'section2', 'path' => '/ru/section2/' },
                                        'section3' => { 'title' => 'section3', 'path' => '/ru/section3/' },
                                        'page4' => { 'title' => 'page4', 'path' => '/ru/page4/' },
                                        'page5' => { 'title' => 'page5', 'path' => '/ru/page5/' }
                                      }
                            }
                      }
      }

      locale.part_for('region').to_json.should == expected_hash
    end

    it '3 level' do
      navigation_part = Fabricate(:navigation_part,
                                  :node => locale,
                                  :region => 'region',
                                  :from_node => locale,
                                  :navigation_default_level => 3)

      expected_hash = {
        'type' => 'NavigationPart',
        'content' => { 'ru' => {
                          'title' => 'ru',
                          'path' => '/ru/',
                          'children' => {
                                'section1' => { 'title' => 'section1', 'path' => '/ru/section1/', 'children' => {
                                  'subsection11' => { 'title' => 'subsection11', 'path' => '/ru/section1/subsection11/', 'children' => {
                                    'page111' => { 'title' => 'page111', 'path' => '/ru/section1/subsection11/page111/' },
                                    'page112' => { 'title' => 'page112', 'path' => '/ru/section1/subsection11/page112/' }
                                  }},
                                  'page11' => { 'title' => 'page11', 'path' => '/ru/section1/page11/' }
                                }},
                                'section2' => { 'title' => 'section2', 'path' => '/ru/section2/' },
                                'section3' => { 'title' => 'section3', 'path' => '/ru/section3/', 'children' => {
                                  'subsection31' => { 'title' => 'subsection31', 'path' => '/ru/section3/subsection31/', 'children' => {
                                    'page311' => {'title' => 'page311', 'path' => '/ru/section3/subsection31/page311/'}
                                }},
                                  'subsection32' => { 'title' => 'subsection32', 'path' => '/ru/section3/subsection32/', 'children' => {
                                    'page321' => { 'title' => 'page321', 'path' => '/ru/section3/subsection32/page321/'}
                                }},
                                  'subsection33' => { 'title' => 'subsection33', 'path' => '/ru/section3/subsection33/', 'children' => {
                                    'page331' => {'title' => 'page331', 'path' => '/ru/section3/subsection33/page331/'}
                                }},
                                }},
                                'page4' => { 'title' => 'page4', 'path' => '/ru/page4/' },
                                'page5' => { 'title' => 'page5', 'path' => '/ru/page5/' }
                              }
                            }
                        }
      }

      locale.part_for('region').to_json.should == expected_hash
    end

    it "показывать раскрытую часть навигации для текущей страницы" do
      page111.update_attribute(:template, :inner_pagei)
      page111.stub(:templates_hash).and_return(YAML.load_file(Rails.root.join('spec/fixtures/sites.yml')).to_hash['sites'][site.slug]['templates'])
      navigation_part = Fabricate(:navigation_part,
                                  :node => locale,
                                  :region => 'navigation',
                                  :from_node => locale,
                                  :navigation_default_level => 1,
                                  :navigation_end_level => 2)

      expected_hash = {
        'type' => 'NavigationPart',
        'content' => { 'ru' => {
                          'title' => 'ru',
                          'path' => '/ru/',
                          'children' => {
                                'section1' => { 'title' => 'section1', 'path' => '/ru/section1/', 'selected' => true, 'children' => {
                                  'subsection11' => { 'title' => 'subsection11', 'path' => '/ru/section1/subsection11/', 'selected' => true },
                                  'page11' => { 'title' => 'page11', 'path' => '/ru/section1/page11/' }
                                }},
                                'section2' => { 'title' => 'section2', 'path' => '/ru/section2/' },
                                'section3' => { 'title' => 'section3', 'path' => '/ru/section3/' },
                                'page4' => { 'title' => 'page4', 'path' => '/ru/page4/' },
                                'page5' => { 'title' => 'page5', 'path' => '/ru/page5/' }
                              }
                            }
                        }
      }
      page111.part_for('navigation', true).to_json.should == expected_hash
    end

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
#  documents_kind           :string(255)
#

