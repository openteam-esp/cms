# encoding: utf-8

class StreamsPart < Part
  validates_presence_of :streams_degree
  attr_accessible :streams_degree
  serialize :streams_degree

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content', 'search_options']))
  end

  def part_title
    title
  end

  def content
    response_hash
  end

  def search_options
    @search_options ||= Requester.new("#{docket_url}/api/streams/search_options").response_hash
  end

  private
    def degrees
      degrees = self.streams_degree.delete_if(&:blank?)
    end

    def exams
      (params[:exams] || []).delete_if(&:blank?)
    end

    def sector
      params[:sector] || nil
    end

    def tuitions
      (params[:tuitions] || []).delete_if(&:blank?)
    end

    def search_params
      { :degrees => degrees, :exams => exams, :sector => sector, :tuitions => tuitions }.to_query
    end

    def docket_url
      Settings['docket.url']
    end

    def url_for_request
      "#{docket_url}/api/streams/?#{search_params}"
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

