class OrganizationListPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :organization_list_item_page_id

  validates_presence_of :organization_list_category_id

  default_value_for :organization_list_per_page, 10

  def categories
    @categories ||= Requester.new("#{blue_pages_url}/categories", 'application/json').response_hash['categories'].map { |c| [c['title'], c['id']] }
  end

  def category_name
    @category_name ||= Requester.new("#{blue_pages_url}/categories/#{organization_list_category_id}", 'application/json').response_hash['title']
  end

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    replace_id_with_links
    set_filters
    response_hash.merge(:pagination => pagination, :query => params['q'])
  end

  alias_attribute :part_title, :title

  private
    def blue_pages_url
      "#{Settings['blue-pages.url']}"
    end

    def url_for_request
      URI.escape "#{blue_pages_url}/innorganizations?#{query}"
    end

    def query
      ''.tap do |s|
        s << "per_page=#{organization_list_per_page}&"
        s << "page=#{page}&"
        s << "q=#{params['q']}&"
        s << filter_params
      end
    end

    def filter_params
      filter_params = %w[sphere status].map { |filter|
        params[filter].delete('_') if params[filter]

        params[filter].map { |v| "#{filter}[]=#{v}" }.join('&') if params[filter]
      }

      filter_params.delete_if { |i| i.blank? }.join('&')
    end

    def page
      params['page'].to_i.zero? ? 1 : params['page'].to_i
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
        'total_count' => total_count,
        'current_page' => current_page,
        'per_page' => organization_list_per_page
      }
    end

    def replace_id_with_links
      response_hash['organizations'].each do |organization|
        organization['link'] = "#{item_page.route_without_site}/-/#{organization.delete('id')}"
      end if response_hash['organizations']
    end

    def set_filters
      %w[sphere status].each do |filter|
        response_hash['filters'][filter].each do |k, v|
          v['checked'] = params[filter].include?(k) ? true : false
        end if params[filter]
      end if response_hash['filters']
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

