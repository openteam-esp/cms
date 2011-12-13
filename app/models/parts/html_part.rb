require 'base64'

class HtmlPart < Part
  validates_presence_of :html_info_path

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def body
    c = Curl::Easy.perform("#{remote_url}&target=r1_#{str_to_hash(html_info_path.gsub(/^\//,''))}")
    JSON.parse(c.body_str)['content']
  end

  def content
    { 'body' => body, 'updated_at' => updated_at }
  end

  private

    def str_to_hash(str)
      Base64.urlsafe_encode64(str).strip.tr('=', '')
    end

    def remote_url
      "#{Settings[:el_vfs][:protocol]}://#{Settings[:el_vfs][:host]}:#{Settings[:el_vfs][:port]}/api/el_finder/v2?format=json&cmd=get"
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
#

