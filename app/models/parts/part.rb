class Part < ActiveRecord::Base
  attr_accessor :current_node, :params

  belongs_to :node

  validates_presence_of :node, :region, :template

  default_value_for :params, {}

  default_value_for :template do |part|
    part.class.name.underscore
  end

  def response
    @response ||= Requester.new(url_for_request)
  end

  delegate :response_body, :response_headers, :response_status, :to => :response

  def available_templates
    [self.class.name.underscore] + (node.site_settings['part_templates'].try(:[], self.class.name.underscore).try(:split, '|' ) || [])
  end

  def error_title
    case response_status
      when 404, 500
        I18n.t("external_system_errors.#{response_status}")
      else
        'Replace me in CMS:app/models/part.rb:21'
    end
  end

  def default_hash
    { 'response_status' => response_status }.tap do |hash|
      hash.merge!('template' => template)

      hash.merge!('title' => error_title) if bad_request?
    end
  end

  def to_json
    default_hash
  end

  def bad_response_statuses
    [404, 500]
  end

  def bad_request?
    bad_response_statuses.include? response_status
  end

  def response_hash
    bad_request? ? default_hash : response.response_hash
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_order_by               :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  blue_pages_expand           :boolean
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  documents_context_id        :integer
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
#

