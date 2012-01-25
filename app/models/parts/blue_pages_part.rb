# encoding: utf-8

class BluePagesPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :blue_pages_item_page_id

  validates_presence_of :blue_pages_category_id

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    content_with_updated_item_links
  end

  def content_with_updated_item_links
    update_item_links ActiveSupport::JSON.decode(request)
  end

  def update_item_links(subdivisions)
    subdivisions['items'].each { |item| item['link'] = "#{item_page.route_without_site}?parts_params[blue_pages_item][link]=#{item['link']}" } if subdivisions['items']
    subdivisions['subdivisions'].each { |subdivision| update_item_links(subdivisions) } if subdivisions['subdivisions']

    subdivisions
  end

  def request
    @request ||= Curl::Easy.http_get("#{blue_pages_url}/#{blue_pages_category_id}#{expand_parameter}.json").body_str
  end

  def expand_parameter
    '?expand=true' if blue_pages_expand
  end

  def categories
    @categories ||= Curl::Easy.http_get("#{blue_pages_url}.json").body_str
  end

  def category_name
    @name ||= ActiveSupport::JSON.decode(Curl::Easy.http_get("#{blue_pages_url}/#{blue_pages_category_id}.json").body_str)['title']
  end

  def categories_options_for_select
    options_for_select = {}
    ActiveSupport::JSON.decode(categories)['categories'].each do |e|
      options_for_select[e['title']] = e['id']
    end

    options_for_select
  end

  private
    def blue_pages_url
      "#{Settings['blue_pages.url']}/categories"
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

