# encoding: utf-8

class AppealPart < Part
  validates_presence_of :appeal_section_slug

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    res = '<div class="remote_wrapper">'
    res << request.force_encoding('utf-8')
    res << '</div>'
    res
  end

  private
    def appeals_url
      "#{Settings['appeals.url']}/public/sections/#{appeal_section_slug}/appeals"
    end

    def request
      @request ||= Curl::Easy.perform("#{appeals_url}/new") do |curl|
        curl.headers['Accept'] = 'text/vnd_html'
      end.body_str
    end
end
# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_order_by               :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  blue_pages_expand           :boolean
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  documents_context_id        :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#

