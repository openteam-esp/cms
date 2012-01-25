# encoding: utf-8

class NewsItemPart < Part
  validates_presence_of :news_channel

  def request
    @request ||= Curl::Easy.perform("#{news_url}/public/channels/#{news_channel}/entries/#{params['slug']}") do |curl|
      curl.headers['Accept'] = 'application/json'
    end.body_str
  end

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    params['slug'] ? ActiveSupport::JSON.decode(request) : ''
  end

  def page_title
    content['title']
  end

  def parts_params
    "?parts_params[news_item][slug]=#{params['slug']}"
  end

  private
    def news_url
      Settings['news.url']
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

