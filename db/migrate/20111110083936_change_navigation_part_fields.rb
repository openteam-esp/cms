class ChangeNavigationPartFields < ActiveRecord::Migration
  def up
    rename_column :parts, :end_level, :navigation_end_level
    remove_column :parts, :start_level
    remove_column :parts, :extra_inactive
    remove_column :parts, :extra_active
  end

  def down
    add_column :parts, :extra_active, :integer
    add_column :parts, :extra_inactive, :integer
    add_column :parts, :start_level, :integer
    rename_column :parts, :navigation_end_level, :end_level
  end
end
