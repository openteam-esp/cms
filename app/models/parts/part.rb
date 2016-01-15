class Part < ActiveRecord::Base
  attr_accessible :title
  attr_accessible :item_page

  attr_accessor :current_node, :params, :resource_id

  belongs_to :node, :touch => true

  validates_presence_of :node, :region, :template

  attr_accessible :node, :region, :template, :type

  after_create :index, :if => :indexable?
  after_update :node_reindex, :if => [:indexable?, :need_to_reindex?]
  after_destroy :node_reindex, :if => :indexable?

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

  audited

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
    node && node.indexable_regions.include?(region)
  end

  def index
    urls_for_index.each do |url|
      begin
        MessageMaker.make_message('esp.cms.searcher', 'add', url)
      rescue => e
        logger.fatal "Error make message with: #{e.inspect}"
      end
    end
  end

  def url
    "#{node.url}##{region}"
  end

  def url_was
    "#{node.url}##{region_was}"
  end

  protected
    def need_to_reindex?
      title_changed? || region_changed? || template_changed?
    end

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

    def urls_for_index
      [node.url]
    end

    delegate :reindex, :to => :node, :prefix => true
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
