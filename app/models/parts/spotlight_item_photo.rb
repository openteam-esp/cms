class SpotlightItemPhoto < ActiveRecord::Base

  attr_accessible :photo

  validates_presence_of :photo

  belongs_to :spotlight_item

  has_attached_file :photo, :storage => :elvfs, :elvfs_url => Settings['storage.url']
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  def file_url
    photo_url
  end

end

# == Schema Information
#
# Table name: spotlight_item_photos
#
#  id                 :integer          not null, primary key
#  spotlight_item_id  :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  photo_url          :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
