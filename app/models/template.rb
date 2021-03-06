class Template < ActiveRecord::Base
  attr_accessible :title, :regions_attributes, :position

  belongs_to :setup

  has_many :regions, dependent: :destroy
  accepts_nested_attributes_for :regions, allow_destroy: true, reject_if: :all_blank

  default_scope order(:position, :id)

  normalize_attribute :title, with: :squish
  normalize_attribute :position, with: :squish
end

# == Schema Information
#
# Table name: templates
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  setup_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#
