class AddCategoryIdToPart < ActiveRecord::Migration
  def change
    add_column :parts, :appeals_category_id, :integer
  end
end
