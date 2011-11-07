class Locale < Node

  has_enum :slug
  belongs_to :site, :foreign_key => :ancestry  #:conditions => 'id = \'#{ancestry}\'', :inverse_of => :locales

end

# == Schema Information
#
# Table name: nodes
#
#  id          :integer         not null, primary key
#  slug        :string(255)
#  title       :string(255)
#  ancestry    :string(255)
#  template_id :integer
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

