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

    def expand_parameter
      '?expand=true' if blue_pages_expand
    end

    def request
      @request ||= Curl::Easy.http_get("#{blue_pages_url}/#{blue_pages_category_id}#{expand_parameter}.json").body_str
    end

    def content_with_updated_item_links
      update_item_links ActiveSupport::JSON.decode(request)
    end

    def update_item_links(subdivisions)
      subdivisions['items'].each { |item| item['link'] = "#{item_page.route_without_site}?parts_params[blue_pages_item][link]=#{item['link']}" } if subdivisions['items']
      subdivisions['subdivisions'].each { |subdivision| update_item_links(subdivision) } if subdivisions['subdivisions']

      subdivisions
    end

    def categories
      @categories ||= Curl::Easy.http_get("#{blue_pages_url}.json").body_str
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_order_by               :string(255)
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
#

