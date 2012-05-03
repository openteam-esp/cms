# encoding: utf-8

class NewsListPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :news_item_page_id

  has_enums

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content', 'border_dates']))
  end

  def content
    return response_hash if bad_request?

    hash = data_hash.update(data_hash) {|v,k| k.each{|l| l['link']="#{item_page.route_without_site}/-/#{l['slug']}"}}

    hash.merge!('collection_link' => collection_link)

    hash.merge!('title' => title) if title?
    hash.merge!(pagination) if news_paginated?
    hash.merge!('rss_link' => rss_link) if news_channel?

    if news_event_entry?
      hash.merge!('first_page' => true) if events_first_page?
      hash.merge!('last_page' => true) if events_last_page?
    end

    hash
  end

  def border_dates
    { 'min_date' => min_event_datetime, 'max_date' => max_event_datetime }
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

  def channels_collection
    @channel_response = Requester.new("#{news_url}/channels")
    @channel_response.response_hash.map { |a| [ "#{'&nbsp;'*a['depth']*2}#{a['title']}".html_safe, a['id'] ] }
  end

  def url_for_request
    "#{news_url}/entries?#{search_params}&#{image_size_params}"
  end

  protected
    def news_url
      Settings['news.url']
    end

    def rss_link
      "#{news_url}/channels/#{news_channel}/entries.rss"
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

    def search_params
      URI.escape("utf8=✓&entry_search[channel_ids][]=#{news_channel}&entry_search[order_by]=#{order_by}&per_page=#{news_per_page}&page=#{current_page}").tap do |s|
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
          'param_name' => 'parts_params[news_list][page]'
        }
      }
    end

    def urls_for_index
      []
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

