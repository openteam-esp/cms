class PartTemplate < ActiveRecord::Base
  attr_accessible :title, :values

  belongs_to :setup
end

# == Schema Information
#
# Table name: part_templates
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  values     :text
#  setup_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
