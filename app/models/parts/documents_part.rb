# encoding: utf-8

require 'uri'

class DocumentsPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :documents_item_page_id

  validates_presence_of :documents_kind

  has_enums

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    { 'action' => action_for_search_form, 'keywords' => keywords, 'context_id' => context_id,  'papers' => papers }.tap do |hash|
      hash.merge!(pagination) if documents_paginated?
    end
  end

  def contexts
    @contexts ||= Restfulie.at("#{documents_url}/contexts").accepts("application/json").get
  end

  def contexts_options_for_select
    options_for_select = {}
    ActiveSupport::JSON.decode(contexts.body).each do |e|
      options_for_select[e['title']] = e['id']
    end

    options_for_select
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    def request
      @request ||= Restfulie.at(query).accepts("application/json").get
    end

    def request_headers
      @request_headers ||= request.headers.merge(request.headers) { |k, v| v.join }
    end

    def request_body
      @request_body ||= ActiveSupport::JSON.decode(request.body)
    end

    def action_for_search_form
      node.route_without_site
    end

    def keywords
      params['keywords'] || ''
    end

    def query_params
      "utf8=✓&#{documents_kind.singularize}_search[keywords]=#{keywords}&#{documents_kind.singularize}_search[context_id]=#{documents_context_id}&page=#{page}&per_page=#{documents_per_page}"
    end

    def page
      params['page'] || 1
    end

    def query
      URI.encode("#{documents_url}/#{documents_kind}?#{query_params}")
    end

    def papers
      change_ids_to_links(request_body).tap do |papers|
        papers.each do |p|
          p['asserted_projects']  = change_ids_to_links(p['asserted_projects'])
          p['canceled_documents'] = change_ids_to_links(p['canceled_documents'])
          p['changed_documents']  = change_ids_to_links(p['changed_documents'])
        end
      end
    end

    def change_ids_to_links(papers)
      if papers
        papers.map { |p| p.merge!('link' => "#{item_page.route_without_site}?parts_params[documents_item][id]=#{p['id']}") }
        papers.each { |p| p.delete('id') }
      else
        []
      end
    end

    def total_pages
      request_headers['x-total-pages'].to_i
    end

    def current_page
      request_headers['x-current-page'].to_i
    end

    def pagination
      result = { 'pagination' => [] }

      return result if total_pages == 1

      result.tap do |hash|
        (1..total_pages).each do |page|
          hash['pagination'] << { 'link' => "?parts_params[documents][page]=#{page}", 'current' => current_page == page ? 'true' : 'false' }
        end
      end
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                       :integer         not null, primary key
#  created_at               :datetime
#  updated_at               :datetime
#  region                   :string(255)
#  type                     :string(255)
#  node_id                  :integer
#  navigation_end_level     :integer
#  navigation_from_id       :integer
#  navigation_default_level :integer
#  news_channel             :string(255)
#  news_order_by            :string(255)
#  news_until               :date
#  news_per_page            :integer
#  news_paginated           :boolean
#  news_item_page_id        :integer
#  blue_pages_category_id   :integer
#  appeal_section_slug      :string(255)
#  blue_pages_expand        :boolean
#  navigation_group         :string(255)
#  title                    :string(255)
#  html_info_path           :string(255)
#  blue_pages_item_page_id  :integer
#  documents_kind           :string(255)
#

