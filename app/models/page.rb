class Page < Node
  belongs_to :template

  has_many :parts
  has_many :contents, :through => :parts

  validates_presence_of :parent, :template


  def locale
    ancestors.second
  end

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

