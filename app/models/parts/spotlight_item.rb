class SpotlightItem < ActiveRecord::Base

  attr_accessible :url, :position

  belongs_to :spotlight

  validates_presence_of :url

  default_scope order(:position, :id)

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
#
