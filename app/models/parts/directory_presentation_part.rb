# encoding: utf-8

class DirectoryPresentationPart < Part
  attr_accessible :directory_presentation_id, :directory_presentation_item_page_id

  belongs_to :item_page, :class_name => 'Node', :foreign_key => :directory_presentation_item_page_id

  validates_presence_of :directory_presentation_id

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    response_hash
  end

  def presentations
    @presentations ||= Requester.new("#{'http://localhost:3000/api/presentations'}", 'application/json').response_hash.
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

