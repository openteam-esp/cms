class DirectoryPostPart < Part
  attr_accessible :directory_post_photo_width, :directory_post_photo_height,
    :directory_post_photo_crop_kind, :directory_post_post_id

  default_value_for :directory_post_photo_width,  100
  default_value_for :directory_post_photo_height, 100

  has_enums

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['content', 'part_title']))
  end

  def content
    response_hash['person_photo_url'] = response_hash['person_photo_url'].gsub(/\/\d+-\d+\//, photo_processing) if response_hash['person_photo_url'].present?
    response_hash.merge!(lectures)

    response_hash
  end

  def part_title
    response_hash['person_full_name']
  end

  alias :page_title :part_title

  private

  def directory_api_url
    "#{Settings['directory.url']}/api"
  end

  def post_id
    directory_post_post_id? ? directory_post_post_id : resource_id
  end

  def url_for_request
    "#{directory_api_url}/posts/#{post_id}"
  end

  def urls_for_index
    []
  end

  def lectures
    requester = Requester.new("#{lecture_disciplines_url}/#{part_title}")
    @lectures ||= requester.response_status == 200 ? { :lectures => requester.response_hash['disciplines'] } : {}
  end

  def lecture_disciplines_url
    "#{Settings['timetable']['url']}/api/v1/lecture_disciplines"
  end

  alias_attribute :photo_width,   :directory_post_photo_width
  alias_attribute :photo_height,  :directory_post_photo_height
  alias_attribute :photo_crop,    :directory_post_photo_crop_kind

  def photo_processing
    "/#{photo_width}-#{photo_height}#{photo_crop}/"
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