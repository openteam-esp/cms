# encoding: utf-8

class GalleryPicture < ActiveRecord::Base
  belongs_to :gallery_part
  validates_presence_of :description, :picture_url

  def resized_picture_url(width = 0)
    return picture_url unless picture_url
    width > 0 ? picture_url.insert(picture_url.rindex('/'), "/#{width}-#{width}") : picture_url
  end
end
# == Schema Information
#
# Table name: gallery_pictures
#
#  id              :integer         not null, primary key
#  gallery_part_id :integer
#  description     :string(255)
#  picture_url     :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

