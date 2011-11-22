class AddCategoryIdToPart < ActiveRecord::Migration
  def change
    add_column :parts, :blue_pages_category_id, :integer
  end
end
