class Template < ActiveRecord::Base
  belongs_to :site
  has_many :regions
end

# == Schema Information
#
# Table name: templates
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  site_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

