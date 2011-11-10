class ChangeNavigationPart < ActiveRecord::Migration
  def up
    rename_column :parts, :navigation_level, :start_level
    rename_column :parts, :navigation_selected_level, :end_level

    add_column :parts, :extra_active, :integer
    add_column :parts, :extra_inactive, :integer
  end

  def down
    remove_column :parts, :extra_inactive
    remove_column :parts, :extra_active

    rename_column :parts, :end_level, :navigation_selected_level
    rename_column :parts, :start_level, :navigation_level
  end
end
