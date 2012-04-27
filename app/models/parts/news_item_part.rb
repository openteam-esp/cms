# encoding: utf-8

class NewsItemPart < Part
  validates_presence_of :news_channel, :news_mlt_count

  default_value_for :news_mlt_count, 0

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    slug ? data_hash : ''
  end

  def part_title
    content['title']
  end

  alias :page_title :part_title

  def path_with_slug(slug)
    "#{node.route_without_site}/-/#{slug}"
  end

  def url_with_slug(slug)
    "#{node.url}-/#{slug}"
  end

  def news_list_url(page = 1)
    URI.escape("#{news_url}?utf8=✓&entry_search[channel_ids][]=#{news_channel}&per_page=50&page=#{page}")
  end

  def news_slugs_for_page(page)
    Requester.new(news_list_url(page), headers_accept).response_hash.map { |item| item['slug'] }
  end

  def news_pages_count
    Requester.new(news_list_url, headers_accept).response_headers['X-Total-Pages'].to_i
  end

  def index
    (1..news_pages_count).each do |page|
      news_slugs_for_page(page).each do |slug|
        MessageMaker.make_message('esp.cms.searcher', 'add', url_with_slug(slug))
      end
    end
  end

  def index_after_destroy
    MessageMaker.make_message('esp.cms.searcher', 'remove', node.url)
  end

  private
    def news_url
      Settings['news.url']
    end

    def image_size_params
      "entries_params[width]=#{news_width}&entries_params[height]=#{news_height}"
    end

    def news_mlt_params
      "more_like_this[count]=#{news_mlt_count}&more_like_this[width]=#{news_mlt_width}&more_like_this[height]=#{news_mlt_height}"
    end

    alias :slug :resource_id

    def url_for_request
      "#{news_url}/channels/#{news_channel}/entries/#{slug}?#{image_size_params}&#{news_mlt_params}"
    end

    def data_hash
      {}.tap do |hash|
        hash.merge!(response_hash)

        hash['more_like_this'] = hash['more_like_this'].each { |e| e['link'] = path_with_slug(e['slug']) } if hash['more_like_this']
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

