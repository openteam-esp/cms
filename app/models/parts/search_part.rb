# encoding: utf-8

class SearchPart < Part
  validates_presence_of :search_per_page

  default_value_for :search_per_page, 15

  alias_attribute :part_title, :title

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    {
      'items' => response_hash,
      'search_query' => query
    }.tap do |hash|
      hash.merge!(pagination)
    end
  end

  private
    def searcher_url
      Settings['searcher.url']
    end

    def site_url
      node.site.client_url
    end

    def site_url
      node.site.client_url
    end

    def query
      params['q']
    end

    def page
      params['page'] || 1
    end

    def request_params
      request_params = "url=#{site_url}"
      request_params << "&q=#{query}"
      request_params << "&page=#{page}"
      request_params << "&per_page=#{search_per_page}"
    end

    def url_for_request
      URI.encode("#{searcher_url}?#{request_params}")
    end

    def total_count
      response_headers['X-Total-Count'].to_i
    end

    def total_pages
      response_headers['X-Total-Pages'].to_i
    end

    def current_page
      response_headers['X-Current-Page'].to_i
    end

    def pagination
      {
        'pagination' => {
          'total_count' => total_count,
          'current_page' => current_page,
          'per_page' => search_per_page,
          'param_name' => 'parts_params[search][page]'
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
#  id                             :integer         not null, primary key
#  created_at                     :datetime        not null
#  updated_at                     :datetime        not null
#  region                         :string(255)
#  type                           :string(255)
#  node_id                        :integer
#  navigation_end_level           :integer
#  navigation_from_id             :integer
#  navigation_default_level       :integer
#  news_channel                   :string(255)
#  news_per_page                  :integer
#  news_paginated                 :boolean
#  news_item_page_id              :integer
#  blue_pages_category_id         :integer
#  appeal_section_slug            :string(255)
#  navigation_group               :string(255)
#  title                          :string(255)
#  html_info_path                 :text
#  blue_pages_item_page_id        :integer
#  documents_kind                 :string(255)
#  documents_item_page_id         :integer
#  documents_paginated            :boolean
#  documents_per_page             :integer
#  youtube_resource_id            :string(255)
#  youtube_item_page_id           :integer
#  youtube_video_resource_id      :string(255)
#  youtube_resource_kind          :string(255)
#  youtube_per_page               :integer
#  youtube_paginated              :boolean
#  youtube_video_resource_kind    :string(255)
#  news_height                    :integer
#  news_width                     :integer
#  news_mlt_count                 :integer
#  news_mlt_width                 :integer
#  news_mlt_height                :integer
#  template                       :string(255)
#  youtube_video_with_related     :boolean
#  youtube_video_related_count    :integer
#  youtube_video_width            :integer
#  youtube_video_height           :integer
#  text_info_path                 :text
#  news_event_entry               :string(255)
#  blue_pages_expand              :integer
#  documents_contexts             :string(255)
#  search_per_page                :integer
#  organization_list_category_id  :integer
#  organization_list_per_page     :integer
#  organization_list_item_page_id :integer
#

