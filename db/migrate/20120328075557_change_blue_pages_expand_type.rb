class ChangeBluePagesExpandType < ActiveRecord::Migration
  def up
    remove_column :parts, :blue_pages_expand
    add_column :parts, :blue_pages_expand, :integer
  end

  def down
    remove_column :parts, :blue_pages_expand
    change_column :parts, :blue_pages_expand, :boolean
  end
end
