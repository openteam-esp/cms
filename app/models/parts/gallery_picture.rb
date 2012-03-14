# encoding: utf-8

class GalleryPicture < ActiveRecord::Base
  belongs_to :gallery_part

  validates_presence_of :description, :picture_url

  default_scope order(:id)

  delegate :create_thumbnail, :thumbnail, :to => :image, :allow_nil => true

  def image
    @image ||= EspCommons::Image.new(:url => picture_url, :description => description).parse_url unless picture_url.blank?
  end

end

# == Schema Information
#
# Table name: gallery_pictures
#
#  id              :integer         not null, primary key
#  gallery_part_id :integer
#  description     :text
#  picture_url     :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

