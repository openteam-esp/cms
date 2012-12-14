# encoding: utf-8

class DocumentsItemPart < Part
  validates_presence_of :documents_kind, :documents_contexts

  normalize_attribute :documents_contexts, :with => [:as_array_of_integer]

  has_enums

  serialize :documents_contexts, Array

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['content', 'part_title']))
  end

  def content
    response_hash.delete('id')

    response_hash.tap do |paper|
      paper['asserted_projects']  = change_ids_to_links(paper['asserted_projects'])
      paper['canceled_documents'] = change_ids_to_links(paper['canceled_documents'])
      paper['changed_documents']  = change_ids_to_links(paper['changed_documents'])
    end
  end

  def part_title
    content['title']
  end

  alias :page_title :part_title

  def contexts
    @contexts ||= Requester.new("#{documents_url}/contexts", headers_accept).response_hash.map { |hash| [hash.keys.first, hash.values.first] }
  end

  def url_for_request
    "#{documents_url}/#{documents_kind}/#{paper_id}?#{context_ids_param}"
  end

  def paper_url(document_id)
    "#{node.url}-/#{document_id}/"
  end

  def papers_list_url(page = 1)
    URI.escape("#{documents_url}/#{documents_kind}?utf8=✓&#{context_ids_params}&per_page=50&page=#{page}")
  end

  def papers_pages_count
    Requester.new(papers_list_url, headers_accept).response_headers['X-Total-Pages'].to_i
  end

  def paper_ids_for_page(page)
    Requester.new(papers_list_url(page), headers_accept).response_hash.map { |item| item['id'] }
  end

  private
    def need_to_reindex?
      documents_contexts_changed? || super
    end

    def documents_url
      "#{Settings['documents.url']}"
    end

    alias :paper_id :resource_id

    def context_ids_param
      documents_contexts.map { |c| "context_ids[]=#{c}" }.join('&')
    end

    def change_ids_to_links(papers)
      return [] unless papers

      papers.map { |p| p.merge!('link' => "#{node.route_without_site}/-/#{p['id']}") }
      papers.each { |p| p.delete('id') }
    end

    def urls_for_index
      (1..papers_pages_count).map { |page|
        paper_ids_for_page(page).map { |id| paper_url(id) }
      }.flatten
    end

    def context_ids_params
      documents_contexts.map { |c| "document_search[context_ids][]=#{c}" }.join('&')
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

