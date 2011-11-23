class AddBluePagesExpandToPart < ActiveRecord::Migration
  def change
    add_column :parts, :blue_pages_expand, :boolean
  end
end
