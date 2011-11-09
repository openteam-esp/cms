class Node < ActiveRecord::Base

  validates :slug, :presence => true, :format => { :with => %r{^[[:alnum:]_\.-]+$} }
  has_ancestry

  normalize_attribute :title, :with => [:squish, :gilensize_as_text, :blank]

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
#  id         :integer         not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  ancestry   :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  template   :string(255)
#

