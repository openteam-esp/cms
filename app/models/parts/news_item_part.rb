# encoding: utf-8

class NewsItemPart < Part
  attr_accessible :news_channel
  attr_accessible :news_event_entry
  attr_accessible :news_height
  attr_accessible :news_item_page_id
  attr_accessible :news_mlt_count
  attr_accessible :news_mlt_number_of_months
  attr_accessible :news_mlt_height
  attr_accessible :news_mlt_width
  attr_accessible :news_paginated
  attr_accessible :news_per_page
  attr_accessible :news_width

  validates_presence_of :news_channel

  default_value_for :news_mlt_count, 0
  validates :news_mlt_count, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  default_value_for :news_mlt_number_of_months, 1
  validates :news_mlt_number_of_months, :presence => true, :numericality => { :only_integer => true, :greater_than => 0 }

  def to_json
    super.merge!(as_json(:only => :type, :methods => [
      'part_title', 'archive_dates', 'archive_statistics',
      'path_to_site_news_list', 'navigation_title_of_site_news_list',
      'content'
    ]))
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

  def path_to_site_news_list
    node.parent.route_without_site
  end

  def navigation_title_of_site_news_list
    node.parent.navigation_title
  end

  def news_slugs_for_page(page)
    Requester.new(news_list_url(page), headers_accept).response_hash.map { |item| item['slug'] }
  end

  def news_pages_count
    response_headers['X-Total-Pages'].to_i
  end

  def channel_description
    channel_hash['description']
  end

  def channels_for_select
    @channels_for_select ||= channels_hash.map { |a| [ "#{'&nbsp;'*a['depth']*2}#{a['title']}".html_safe, a['id'] ] }
  end

  def archive_dates
    channel_hash['archive_dates']
  end

  def archive_statistics
    channel_hash['archive_statistics']
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
      "more_like_this[count]=#{news_mlt_count}&more_like_this[months]=#{news_mlt_number_of_months}&more_like_this[width]=#{news_mlt_width}&more_like_this[height]=#{news_mlt_height}"
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

    def channel_hash
      @channel_hash ||= Requester.new("#{news_url}/channels/#{news_channel}", headers_accept).response_hash
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

