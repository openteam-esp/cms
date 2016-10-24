class PromoSlide < ActiveRecord::Base

  attr_accessible :title, :url, :target_blank, :video_url, :annotation, :position, :image

  belongs_to :promo_part

  validates_presence_of :title

  default_scope order(:position, :id)

  default_value_for :target_blank, false

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def file_url
    image_url
  end

end

# == Schema Information
#
# Table name: promo_slides
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  url                :text
#  video_url          :text
#  annotation         :text
#  position           :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_url          :text
#  promo_part_id      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  target_blank       :boolean
#
