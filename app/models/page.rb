class Page < Node
  has_many :parts
  has_many :contents, :through => :parts

  validates_presence_of :parent, :template

  alias :node :parent

  def locale
    ancestors.second
  end
<<<<<<< HEAD

  def part_for(region)
    parts.where(:region => region).first
  end

=======
>>>>>>> #8679. К locale привязать контент
end

# == Schema Information
#
# Table name: nodes
#
#  id         :integer         not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  ancestry   :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  template   :string(255)
#

