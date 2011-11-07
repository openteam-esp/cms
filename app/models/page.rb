class Page < ActiveRecord::Base
  belongs_to :locale
  belongs_to :template
  belongs_to :site

  has_many :parts
  has_many :contents, :through => :parts

  validates :template, :presence => true

  has_ancestry

  alias :pages :children

  def to_s
    slug
  end

end

# == Schema Information
#
# Table name: pages
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  locale_id   :integer
#  ancestry    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  template_id :integer
#

