# encoding: utf-8

class NewsItemPart < Part
  validates_presence_of :news_channel

  def request
    @request ||= Restfulie.at("#{news_url}/public/channels/#{news_channel}/entries/#{params['slug']}").accepts("application/json").get
  end

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    params['slug'] ? ActiveSupport::JSON.decode(request.body) : ''
  end

  def page_title
    content['title']
  end

  def parts_params
    "?parts_params[news_item][slug]=#{params['slug']}"
  end

  private
    def news_url
      "#{Settings['news.protocol']}://#{Settings['news.host']}:#{Settings['news.port']}"
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                       :integer         primary key
#  html_content_id          :integer
#  created_at               :timestamp
#  updated_at               :timestamp
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
#

