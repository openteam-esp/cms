class Region < ActiveRecord::Base
  belongs_to :template
end

# == Schema Information
#
# Table name: regions
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  template_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

