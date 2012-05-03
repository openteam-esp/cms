require 'base64'

class HtmlPart < Part
  validates_presence_of :html_info_path

  after_create :register_in_storage
  after_update :reregister_in_storage
  after_destroy :unregister_in_storage

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def part_title
    title
  end

  def content
    { 'body' => body, 'updated_at' => updated_at }
  end

  def body
    begin
      JSON.parse(response_body)['content'].gsub(/<p>\s*<\/p>/, "").gsub('&mdash;', '&ndash;').gilensize(:skip_attr => true)
    rescue Exception => e
      ["HTML_INFO_PATH = #{html_info_path}", "RESPONSE STATUS = #{response_status}"].join('<br />').html_safe
    end
  end

  private
    def remote_url
      "#{Settings['storage.url']}/api/el_finder/v2?format=json&cmd=get"
    end

    def str_to_hash(str)
      Base64.urlsafe_encode64(str).strip.tr('=', '')
    end

    def url_for_request
      "#{remote_url}&target=r1_#{str_to_hash(html_info_path.gsub(/^\//,''))}"
    end

    def register_in_storage
      MessageMaker.make_message 'esp.cms.storage', 'lock', :url => url, :path => html_info_path
    end

    def reregister_in_storage
      MessageMaker.make_message 'esp.cms.storage', 'unlock', :url => url_was, :path => html_info_path_was
      MessageMaker.make_message 'esp.cms.storage', 'lock', :url => url, :path => html_info_path
    end

    def unregister_in_storage
      MessageMaker.make_message 'esp.cms.storage', 'unlock', :url => url, :path => html_info_path
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#  news_mlt_count              :integer
#  news_mlt_width              :integer
#  news_mlt_height             :integer
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#  text_info_path              :string(255)
#  news_event_entry            :string(255)
#  blue_pages_expand           :integer
#  documents_contexts          :string(255)
#  search_per_page             :integer
#

