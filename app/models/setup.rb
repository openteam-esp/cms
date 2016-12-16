class Setup < ActiveRecord::Base
  attr_accessible :templates_attributes

  belongs_to :site

  has_many :templates, dependent: :destroy

  accepts_nested_attributes_for :templates, allow_destroy: true, reject_if: :all_blank
end

# == Schema Information
#
# Table name: site_settings
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
