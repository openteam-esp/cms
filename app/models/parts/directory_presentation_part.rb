class DirectoryPresentationPart < Part
  attr_accessible :directory_presentation_id, :directory_presentation_item_page_id,
    :directory_presentation_photo_width, :directory_presentation_photo_height,
    :directory_presentation_photo_crop_kind

  belongs_to :item_page, :class_name => 'Node', :foreign_key => :directory_presentation_item_page_id

  validates_presence_of :directory_presentation_id

  default_value_for :directory_presentation_photo_width,  100
  default_value_for :directory_presentation_photo_height, 100

  has_enums

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    response_hash.map { |e|
      e['link'] = "#{item_page.route_without_site}/-/#{e.delete('id')}" if item_page.present?
      e['person_photo_url'] = e['person_photo_url'].gsub(/\/\d+-\d+\//, photo_processing) if e['person_photo_url'].present?

      e
    }
  end

  def presentations
    @presentations ||= Requester.new("#{directory_api_url}/presentations", 'application/json').response_hash.
      map { |e| Hashie::Mash.new(e) }.
      map { |presentation| [presentation.title, presentation.id] }
  end

  def presentation
    @presentation ||= Hashie::Mash.new(Requester.new("#{directory_api_url}/presentations/#{presentation_id}", 'application/json').response_hash)
  end

  delegate :title, to: :presentation, prefix: true

  alias_attribute :part_title,      :title
  alias_attribute :presentation_id, :directory_presentation_id

  private

  def directory_api_url
    "#{Settings['directory.url']}/api"
  end

  def url_for_request
    "#{directory_api_url}/presentations/#{presentation_id}/posts"
  end

  alias_attribute :photo_width,   :directory_presentation_photo_width
  alias_attribute :photo_height,  :directory_presentation_photo_height
  alias_attribute :photo_crop,    :directory_presentation_photo_crop_kind

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
#  priem_context_id                       :integer
#  priem_context_kind                     :string(255)
#  priem_kinds                            :string(255)
#  priem_forms                            :string(255)
#
