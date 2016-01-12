class GpoProjectListPart < Part
  validates_presence_of :gpo_project_list_chair_id

  attr_accessible :gpo_project_list_chair_id

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    return response_hash if bad_request?

    hash = data_hash.dup

    hash.merge!('title' => title) if title?

    hash
  end

  def part_title
    title
  end

  def data_hash
    { 'items' => response_hash }
  end

  def chairs
    @chairs ||= chairs_hash.map {|c| [c['title'], c['id']]}
  end

  def chair_name
    @chair_name ||= Requester.new("#{gpo_url}/api/chairs/#{gpo_project_list_chair_id}").response_hash['title']
  end

  protected
    def url_for_request
      "#{gpo_url}/api/chairs/#{gpo_project_list_chair_id}/projects"
    end

    def gpo_url
      Settings['gpo.url']
    end

    def chairs_hash
      @chairs_hash ||= Requester.new("#{gpo_url}/api/chairs").response_hash
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
#  news_height                            :integer
#  news_width                             :integer
#  news_mlt_count                         :integer
#  news_mlt_width                         :integer
#  news_mlt_height                        :integer
#  template                               :string(255)
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
#  directory_subdivision_id               :integer
#  directory_depth                        :integer
#
