class Part < ActiveRecord::Base
  attr_accessor :current_node, :params, :resource_id

  belongs_to :node

  validates_presence_of :node, :region, :template

  default_value_for :params, {}

  default_value_for :template do |part|
    part.class.name.underscore
  end

  def headers_accept
    'application/json'
  end

  def response
    @response ||= Requester.new(url_for_request, headers_accept)
  end

  delegate :response_body,
           :response_headers,
           :response_status, :to => :response

  def available_templates
    [self.class.name.underscore] + templates_from_settings
  end

  def to_json
    {}.tap do |hash|
      hash.merge!('template' => template)

      hash.merge!('response_status' => response_status) if response_status
      hash.merge!('title' => error_title) if bad_request?
    end
  end

  def response_hash
    bad_request? ? {} : response.response_hash
  end

  def indexable?
    node.indexable_regions.include? region
  end

  protected
    def error_title
      case response_status
        when 404, 500
          I18n.t("external_system_errors.#{response_status}")
        when nil
          ''
        else
          'Replace me in CMS:app/models/part.rb:51'
      end
    end

    def bad_response_statuses
      [400, 404, 500]
    end

    def bad_request?
      bad_response_statuses.include? response_status
    end

    def templates_from_settings
      node.site_settings['part_templates'].try(:[], self.class.name.underscore).try(:split, '|' ) || []
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#  news_mlt_count              :integer
#  news_mlt_width              :integer
#  news_mlt_height             :integer
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#  text_info_path              :string(255)
#  news_event_entry            :string(255)
#  blue_pages_expand           :integer
#  documents_contexts          :string(255)
#  search_per_page             :integer
#

