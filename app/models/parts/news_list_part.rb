# encoding: utf-8

class NewsListPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :news_item_page_id

  validates_presence_of :news_order_by

  has_enums

  def to_json
    as_json(:only => [:type, :title], :methods => 'content')
  end

  def content
    hash = request_body.update(request_body) {|v,k| k.each{|l| l['link']="#{item_page.route_without_site}?parts_params[news_item][slug]=#{l['slug']}"}}
    hash.merge!('title' => title) if title?
    hash.merge!(pagination) if news_paginated?
    hash
  end

  def image_size_params
    "entries_params[width]=#{news_width}&entries_params[height]=#{news_height}"
  end

  private
    def news_url
      Settings['news.url']
    end

    def request
      @request ||= Curl::Easy.perform("#{news_url}/channels/#{news_channel}/entries?#{search_path}&#{image_size_params}") do |curl|
        curl.headers['Accept'] = 'application/json'
      end
    end

    def request_body
      { 'items' => ActiveSupport::JSON.decode(request.body_str) }
    end

    def request_headers
      @request_headers ||= Hash[request.header_str.split("\r\n").map { |s| s.split(':').map(&:strip) }]
    end

    def search_path
      news_until = ::I18n.l(news_until) if news_until

      URI.escape "utf8=✓&entry_search[channel_ids][]=#{news_channel}&entry_search[order_by]=#{news_order_by.gsub(/_/,'+')}&per_page=#{news_per_page}&page=#{params['page'] || '1'}"
    end

    def total_count
      request_headers['X-Total-Count'].to_i
    end

    def total_pages
      request_headers['X-Total-Pages'].to_i
    end

    def current_page
      request_headers['X-Current-Page'].to_i
    end

    def pagination
      {
        'pagination' => {
          'total_count' => total_count,
          'current_page' => current_page,
          'per_page' => news_per_page,
          'param_name' => 'parts_params[news_list][page]'
        }
      }
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

