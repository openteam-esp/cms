class GalleryPicture < ActiveRecord::Base

  attr_accessible :description, :picture_url, :position

  belongs_to :gallery_part

  validates_presence_of :picture_url

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
      MessageMaker.make_message('esp.cms.storage', 'lock_by_url', external_url: url, entry_url: picture_url) if Rails.env.production?
    end

    def reregister_in_storage
      MessageMaker.make_message('esp.cms.storage', 'unlock_by_url', external_url: url, entry_url: picture_url_was) if Rails.env.production?
      MessageMaker.make_message('esp.cms.storage', 'lock_by_url', external_url: url, entry_url: picture_url) if Rails.env.production?
    end

    def unregister_in_storage
      MessageMaker.make_message('esp.cms.storage', 'unlock_by_url', external_url: url, entry_url: picture_url) if Rails.env.production?
    end
end

# == Schema Information
#
# Table name: gallery_pictures
#
#  id              :integer          not null, primary key
#  gallery_part_id :integer
#  description     :text
#  picture_url     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  position        :integer
#

