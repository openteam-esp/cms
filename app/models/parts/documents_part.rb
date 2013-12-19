# encoding: utf-8

class DocumentsPart < Part
  attr_accessible :documents_contexts
  attr_accessible :documents_item_page_id
  attr_accessible :documents_kind
  attr_accessible :documents_paginated
  attr_accessible :documents_per_page

  belongs_to :item_page, :class_name => 'Node', :foreign_key => :documents_item_page_id

  validates_presence_of :documents_kind, :documents_contexts, :item_page

  serialize :documents_contexts, Array

  normalize_attribute :documents_contexts, :with => [:as_array_of_integer]

  default_value_for :documents_per_page, 10

  has_enums

  alias_attribute :part_title, :title

  def content
    { 'action' => action_for_search_form,
      'keywords' => keywords,
      'papers' => papers,
      'rss_link' => rss_link
    }.tap do |hash|
      hash.merge!(pagination) if documents_paginated?
    end
  end

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def contexts
    @contexts ||= Requester.new("#{documents_url}/contexts.json").response_hash.map { |hash| [hash.keys.first, hash.values.first] }
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    def keywords
      params['keywords'] || ''
    end

    def page
      params['page'] || 1
    end

    def context_ids_param
      documents_contexts.map { |context_id|
        "&#{documents_kind.singularize}_search[context_ids][]=#{context_id}"
      }.join
    end

    def query_params
      query_params = "utf8=✓"
      query_params << "&#{documents_kind.singularize}_search[keywords]=#{keywords}"
      query_params << context_ids_param
      query_params << "&page=#{page}"
      query_params << "&per_page=#{documents_per_page}"
    end

    def url_for_request
      URI.encode("#{documents_url}/#{documents_kind}?#{query_params}")
    end

    def action_for_search_form
      node.route_without_site
    end

    def papers
      change_ids_to_links(response_hash).tap do |papers|
        papers.each do |p|
          p['asserted_projects']  = change_ids_to_links(p['asserted_projects'])
          p['canceled_documents'] = change_ids_to_links(p['canceled_documents'])
          p['changed_documents']  = change_ids_to_links(p['changed_documents'])
        end
      end
    end

    def change_ids_to_links(papers)
      return [] unless papers

      papers.map { |p| p.merge!('link' => "#{item_page.route_without_site}/-/#{p['id']}") } if item_page
      papers.each { |p| p.delete('id') }
    end

    def total_count
      response_headers['X-Total-Count'].to_i
    end

    def total_pages
      response_headers['X-Total-Pages'].to_i
    end

    def current_page
      response_headers['X-Current-Page'].to_i
    end

    def pagination
      {
        'pagination' => {
          'total_count' => total_count,
          'current_page' => current_page,
          'per_page' => documents_per_page,
          'param_name' => 'parts_params[documents][page]'
        }
      }
    end

    def rss_link
      params = "utf8=✓#{context_ids_param}"

      URI.encode("#{documents_url}/#{documents_kind}.rss?#{params}")
    end

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

