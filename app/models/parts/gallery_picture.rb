# encoding: utf-8
class GalleryPicture < ActiveRecord::Base

  attr_accessible :description, :picture_url, :position

  belongs_to :gallery_part

  validates_presence_of :description, :picture_url

  default_scope order(:position, :id)

  after_create :register_in_storage
  after_update :reregister_in_storage, :if => :picture_url_changed?
  after_destroy :unregister_in_storage

  delegate :create_thumbnail, :thumbnail, :to => :image, :allow_nil => true

  def image
    @image ||= EspCommons::Image.new(:external_url => picture_url, :description => description).parse_url if picture_url?
  end

  private
    def url
      "#{gallery_part.url}##{id}"
    end

    def register_in_storage
      MessageMaker.make_message 'esp.cms.storage', 'lock_by_url', :external_url => url, :entry_url => picture_url
    end

    def reregister_in_storage
      MessageMaker.make_message 'esp.cms.storage', 'unlock_by_url', :external_url => url, :entry_url => picture_url_was
      MessageMaker.make_message 'esp.cms.storage', 'lock_by_url', :external_url => url, :entry_url => picture_url
    end

    def unregister_in_storage
      MessageMaker.make_message 'esp.cms.storage', 'unlock_by_url', :external_url => url, :entry_url => picture_url
    end
end

# == Schema Information
#
# Table name: gallery_pictures
#
#  created_at      :datetime         not null
#  description     :text
#  gallery_part_id :integer
#  id              :integer          not null, primary key
#  picture_url     :string(255)
#  position        :integer
#  updated_at      :datetime         not null
#

