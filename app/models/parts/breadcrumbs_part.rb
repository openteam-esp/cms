class BreadcrumbsPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    hash = {}
    return hash if current_node.is_a? Locale
    current_node.path[1..-2].each do |n|
      n.parts_params = current_node.parts_params
      hash.merge!(n.page_title => n.page_route)
    end
    hash.merge!(current_node.page_title => current_node.page_route)
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
#  title                    :string(255)
#

