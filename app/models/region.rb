class Region < ActiveRecord::Base
  attr_accessible :configurable, :indexable, :required, :title

  belongs_to :template
end

# == Schema Information
#
# Table name: regions
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  required     :boolean          default(FALSE)
#  configurable :boolean          default(FALSE)
#  indexable    :boolean          default(FALSE)
#  template_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
