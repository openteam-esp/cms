class Node < ActiveRecord::Base
  validates_presence_of :slug
  has_ancestry

  alias :site :root

  def to_s
    slug
  end

  def pages
    Page.where(:ancestry => child_ancestry)
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

