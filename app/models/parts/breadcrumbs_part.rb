class BreadcrumbsPart < Part
  def to_json
    super.merge!(as_json(:only => :type, :methods => ['content', 'extend_content']))
  end

  def response_status
    nil
  end

  def content
    hash = {}

    return hash if current_node.is_a? Locale

    current_node.path[1..-2].each do |n|
      n.parts_params = current_node.parts_params
      hash.merge!(n.page_title => n.page_route)
    end

    hash.merge!(current_node.page_title => current_node.page_route)
  end

  def extend_content
    content = []

    return content if current_node.is_a? Locale

    current_node.path[1..-2].each do |n|
      n.parts_params = current_node.parts_params
      content << {
        :title => n.page_title,
        :slug => n.slug,
        :path => n.page_route,
        :external_link => n.external_link,
      }
    end
    content << {
      :title => current_node.page_title,
      :slug => current_node.slug,
      :path => current_node.page_route,
      :external_link => current_node.external_link,
    }

    content
  end

  private
    def urls_for_index
      []
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

