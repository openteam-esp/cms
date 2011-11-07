class Site < Node
  has_many :templates
  has_many :locales, :finder_sql => 'SELECT "nodes".* FROM "nodes"  WHERE "nodes"."ancestry" = \'#{id}\'', :foreign_key => :ancestry

  accepts_nested_attributes_for :locales, :reject_if => :all_blank, :allow_destroy => true
  default_value_for :locales_attributes, [ { :slug => :ru } ]

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

