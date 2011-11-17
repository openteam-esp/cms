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
    params ? ActiveSupport::JSON.decode(request.body) : ''
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
#  id                       :integer         not null, primary key
#  html_content_id          :integer
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
#

