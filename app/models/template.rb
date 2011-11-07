class Template < ActiveRecord::Base

  belongs_to :site
  has_many :regions

  accepts_nested_attributes_for :regions, :reject_if => :all_blank, :allow_destroy => true

  def to_s
    "#{title} (#{slug})"
  end

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
#  slug       :string(255)
#

