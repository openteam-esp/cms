class BreadcrumbsPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    hash = {}
    return hash if current_node.is_a? Locale
    current_node.path[1..-1].each do |n|
      hash.merge!(n.title => n.route_without_site)
    end
    hash
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

