# encoding: utf-8

class NewsItemPart < Part
  validates_presence_of :news_channel, :news_mlt_count

  default_value_for :news_mlt_count, 0

  def to_json
    as_json(:only => :type, :methods => ['part_title', 'content'])
  end

  def content
    slug ? data_hash : ''
  end

  def part_title
    content['title']
  end

  def page_title
    part_title
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

    def slug
      params['slug']
    end

    def url_for_request
      "#{news_url}/channels/#{news_channel}/entries/#{slug}?#{image_size_params}&#{news_mlt_params}"
    end

    def title_for_error
      case response_status
        when 404
          I18n.t("external_system_errors.#{response_status}")
        else
          'Replace me in CMS:app/models/news_item_part.rb:50'
      end
    end

    def data_hash
      { 'response_status' => response_status, 'title' => title_for_error}.tap do |hash|
        hash.merge!(response_status == 404 ? {} : response_hash)

        hash['more_like_this'] = hash['more_like_this'].each { |e| e['link'] = "#{node.route_without_site}?parts_params[news_item][slug]=#{e['slug']}" } if hash['more_like_this']
      end
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
#

