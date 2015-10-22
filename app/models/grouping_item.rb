class GroupingItem < ActiveRecord::Base
  attr_accessible :group, :title, :position
end

# == Schema Information
#
# Table name: grouping_items
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  group              :string(255)
#  navigation_part_id :integer
#  position           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
