# encoding: utf-8

class GalleryPart < Part
  has_many :gallery_pictures
  accepts_nested_attributes_for :gallery_pictures

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    hash = { :title => title }
    gallery = []
    gallery_pictures.each do |picture|
      gallery << {:picture_url => picture.picture_url, :description => picture.description}
    end
    hash['gallery_pictures'] = gallery
    hash
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
#

