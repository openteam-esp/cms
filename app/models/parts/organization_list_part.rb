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
    {
      :items => response_hash,
      :pagination => pagination
    }
  end

  private
    def blue_pages_url
      "#{Settings['blue-pages.url']}"
    end

    def url_for_request
      "#{blue_pages_url}/innorganizations?#{search_params}"
    end

    def search_params
      ''.tap do |s|
        s << "per_page=#{organization_list_per_page}&"
        s << "page=#{page}"
      end
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

