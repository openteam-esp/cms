# encoding: utf-8

class NewsListPart < Part
  attr_accessible :news_channel
  attr_accessible :news_event_entry
  attr_accessible :news_height
  attr_accessible :news_item_page_id
  attr_accessible :news_mlt_count
  attr_accessible :news_mlt_height
  attr_accessible :news_mlt_width
  attr_accessible :news_paginated
  attr_accessible :news_per_page
  attr_accessible :news_width
  attr_accessible :item_page

  belongs_to :item_page, :class_name => 'Node', :foreign_key => :news_item_page_id

  validates_presence_of :news_channel, :item_page

  has_enums

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'archive_dates', 'content']))
  end

  def content
    return response_hash if bad_request?

    hash = data_hash.update(data_hash) {|v,k| k.each{|l| l['link']="#{item_page.route_without_site}/-/#{l['slug']}"}}

    hash.merge!('collection_link' => collection_link)

    hash.merge!('title' => title) if title?
    hash.merge!('rss_link' => rss_link) if news_channel?
    hash.merge!(pagination) if news_paginated?

    hash
  end

  def archive_dates
    { 'min_date' => min_archive_date, 'max_date' => max_archive_date }
  end

  def collection_link
    item_page.parent.route_without_site
  end

  def part_title
    title
  end

  def data_hash
    { 'items' => response_hash }
  end

  def channel_description
    @channel_description ||= Requester.new("#{news_url}/channels/#{news_channel}", headers_accept).response_hash['description']
  end

  def channels_for_select
    @channels_for_select ||= channels_hash.map { |a| [ "#{'&nbsp;'*a['depth']*2}#{a['title']}".html_safe, a['id'] ] }
  end

  def disabled_channel_ids
    channels_hash.select { |channel| channel['entry_type'].nil? || channel['entry_type'] != "#{self.class.name.underscore.split('_').first.singularize}_entry" }.map { |channel| channel['id'] }
  end

  def url_for_request
    "#{news_url}/entries?#{search_params}&#{image_size_params}"
  end

  protected
    def news_url
      Settings['news.url']
    end

    def rss_link
      path_param = ''
      path_param << item_page.node.site.client_url
      path_param << item_page.route_without_site
      "#{news_url}/channels/#{news_channel}/entries.rss?path_param=#{path_param}"
    end

    def order_by
      'since desc'
    end

    def interval_year
      params['interval_year']
    end

    def interval_month
      params['interval_month']
    end

    def archive_params
      ''.tap do |s|
        s << "&entry_search[interval_year]=#{interval_year}" if interval_year
        s << "&entry_search[interval_month]=#{interval_month}" if interval_month
      end
    end

    def entry_type
      "#{self.class.name.underscore.split('_').first}"
    end

    def search_params
      URI.escape("utf8=✓&entry_search[entry_type]=#{entry_type}&entry_search[channel_ids][]=#{news_channel}&per_page=#{news_per_page}&page=#{current_page}").tap do |s|
        s << archive_params
      end
    end

    def image_size_params
      "entries_params[width]=#{news_width}&entries_params[height]=#{news_height}"
    end

    def total_count
      response_headers['X-Total-Count'].to_i
    end

    def total_pages
      response_headers['X-Total-Pages'].to_i
    end

    def current_page
      (params['page'] || 1).to_i
    end

    def pagination
      {
        'pagination' => {
          'total_count' => total_count,
          'current_page' => current_page,
          'per_page' => news_per_page,
          'param_name' => "parts_params[#{entry_type}_list][page]"
        }
      }
    end

    def urls_for_index
      []
    end

    def min_archive_date
      response_headers['X-Min-Date']
    end

    def max_archive_date
      response_headers['X-Max-Date']
    end

    def channels_hash
      @channels_hash ||= Requester.new("#{news_url}/channels").response_hash
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

