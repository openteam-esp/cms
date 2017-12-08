class TemperatureItem < ActiveRecord::Base
  belongs_to :temperature_part
  attr_accessible :title, :url, :position

  default_scope order(:position)

  def value
    return '&mdash;' unless url =~ URI::regexp
    @value ||= Requester.new(url).response_body
  end
end

# == Schema Information
#
# Table name: temperature_items
#
#  id                  :integer          not null, primary key
#  temperature_part_id :integer
#  title               :string(255)
#  url                 :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  position            :integer
#
