class BluePagesItemPart < Part
  def request
    @request ||= Restfulie.at("#{blue_pages_url}/#{params['link']}").accepts("application/json").get
  end

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    params['link'] ? ActiveSupport::JSON.decode(request.body) : ''
  end

  def blue_pages_url
    Settings['blue_pages.url']
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

