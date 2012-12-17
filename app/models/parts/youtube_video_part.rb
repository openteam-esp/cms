class YoutubeVideoPart < Part
  attr_accessible :youtube_video_height
  attr_accessible :youtube_video_related_count
  attr_accessible :youtube_video_resource_id
  attr_accessible :youtube_video_resource_kind
  attr_accessible :youtube_video_width
  attr_accessible :youtube_video_with_related

  validates_presence_of :youtube_video_resource_id, :youtube_video_resource_kind

  has_enums

  default_value_for :youtube_video_related_count, 5
  default_value_for :youtube_video_width, 560
  default_value_for :youtube_video_height, 315

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  delegate :info,
           :title,
           :related_video_entries, :to => :youtube_video, :prefix => true

  delegate :response_status,
           :video_id,
           :video_description,
           :video_title,
           :video_uploaded,
           :video_thumb_small,
           :video_thumb_normal, :to => :youtube_video

  def content
    return {} if bad_request?

    youtube_video_info.tap do |hash|
      hash.merge!('related_videos' => related_videos) if youtube_video_with_related?
    end
  end

  def page_title
    youtube_video_title unless youtube_video_info.empty?
  end

  alias :part_title :page_title

  private
    def youtube_video
      Youtube::Video.new(:id => resource_id,
                         :resource_id => youtube_video_resource_id,
                         :resource_kind => youtube_video_resource_kind,
                         :params => params,
                         :node => node,
                         :height => youtube_video_height,
                         :width => youtube_video_width,
                         :related_videos_max_results => youtube_video_related_count)
    end

    def related_videos
      youtube_video_related_video_entries.map do |e|
        video_id = video_id(e)

        {
          'link' => "#{node.route_without_site}/-/#{video_id}",
          'title' => video_title(e),
          'description' => video_description(e),
          'date' => video_uploaded(e),
          'thumb_small'  => video_thumb_small(video_id),
          'thumb_normal'  => video_thumb_normal(video_id)
        }
      end
    end

    def urls_for_index
      []
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

