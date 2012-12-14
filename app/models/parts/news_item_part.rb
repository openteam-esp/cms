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
    "#{node.url}-/#{slug}/"
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

  def channel_description
    @channel_description ||= Requester.new("#{news_url}/channels/#{news_channel}", headers_accept).response_hash['description']
  end

  def channels_for_select
    @channels_for_select ||= channels_hash.map { |a| [ "#{'&nbsp;'*a['depth']*2}#{a['title']}".html_safe, a['id'] ] }
  end

  private
    def need_to_reindex?
      news_channel_changed? || super
    end

    def news_url
      Settings['news.url']
    end

    def urls_for_index
      (1..news_pages_count).map { |page|
        news_slugs_for_page(page).map { |slug| url_with_slug(slug) }
      }.flatten
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

    def channels_hash
      @channels_hash ||= Requester.new("#{news_url}/channels").response_hash
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

