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
    {
      'action' => action_for_search_form,
      'keywords' => keywords,
      'papers' => papers
    }
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    def request
      @request ||= Restfulie.at(query).accepts("application/json").get
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
      "utf8=✓&#{documents_kind.singularize}_search[keywords]=#{keywords}"
    end

    def query
      URI.encode("#{documents_url}/#{documents_kind}?#{query_params}")
    end

    def papers
      request_body.map { |p| p.merge!('link' => "#{item_page.route_without_site}?parts_params[documents_item][id]=#{p['link']}") }
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

