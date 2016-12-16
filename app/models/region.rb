class Region < ActiveRecord::Base
  attr_accessible :configurable, :indexable, :required, :title, :position

  belongs_to :template

  default_scope order(:position, :id)
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
#  position     :integer
#
