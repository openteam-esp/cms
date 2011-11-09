class ChangePartFields < ActiveRecord::Migration
  def up
    rename_column :parts, :descendants_level, :navigation_level
    rename_column :parts, :selected_descendants_level, :navigation_selected_level
    add_column :parts, :navigation_from_id, :integer

    rename_column :parts, :content_id, :html_content_id
  end

  def down
    rename_column :parts, :navigation_level, :descendants_level
    rename_column :parts, :navigation_selected_level, :selected_descendants_level
    remove_column :parts, :navigation_from_id

    rename_column :parts, :html_content_id, :content_id
  end
end
