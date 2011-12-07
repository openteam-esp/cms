# encoding: utf-8

class AppealPart < Part
  validates_presence_of :appeal_section_slug

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    res = '<div class="remote_wrapper">'
    res << request.body.force_encoding('utf-8')
    res << '</div>'
    res
  end

  def request
    @request ||= Restfulie.at("#{appeals_url}/new").accepts("text/vnd_html").get
  end

  private
    def appeals_url
      "#{Settings['appeals.protocol']}://#{Settings['appeals.host']}:#{Settings['appeals.port']}/public/sections/#{appeal_section_slug}/appeals"
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
#  news_item_page_id        :integer
#  blue_pages_category_id   :integer
#  appeal_section_slug      :string(255)
#  blue_pages_expand        :boolean
#  navigation_group         :string(255)
#

