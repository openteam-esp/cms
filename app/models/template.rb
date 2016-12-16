class Template < ActiveRecord::Base
  attr_accessible :title

  belongs_to :site_settings

  has_many :regions, dependent: :destroy

  accepts_nested_attributes_for :regions, allow_destroy: true, reject_if: :all_blank
end

# == Schema Information
#
# Table name: templates
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  site_settings_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
