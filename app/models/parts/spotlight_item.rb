class SpotlightItem < ActiveRecord::Base

  attr_accessible :kind, :url, :title, :annotation, :legend, :since, :starts_on, :ends_on, :position,
    :spotlight_item_photos_attributes

  belongs_to :spotlight_part

  validates_presence_of :kind, :title, :url

  validates_presence_of :annotation,  :if => :kind_news?
  validates_presence_of :since,       :if => :kind_news?

  validates_presence_of :annotation,  :if => :kind_event?
  validates_presence_of :starts_on,   :if => :kind_event?
  validates_presence_of :ends_on,     :if => :kind_event?

  validates_presence_of :since,       :if => :kind_photo?

  validates_presence_of :since,       :if => :kind_video?

  validates_presence_of :annotation,  :if => :kind_other?

  has_many :spotlight_item_photos, :order => 'created_at', :dependent => :destroy
  accepts_nested_attributes_for :spotlight_item_photos, :allow_destroy => true

  default_scope order(:position, :id)

  extend Enumerize
  enumerize :kind, :in => [:news, :event, :photo, :video, :other], :default => :news, :predicates => { :prefix => true }

end

# == Schema Information
#
# Table name: spotlight_items
#
#  id                :integer          not null, primary key
#  url               :text
#  position          :integer
#  spotlight_part_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  kind              :string(255)
#  title             :string(255)
#  annotation        :text
#  legend            :string(255)
#  since             :datetime
#  starts_on         :datetime
#  ends_on           :datetime
#
