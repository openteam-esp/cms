class ChangeInfoPathInParts < ActiveRecord::Migration
  def up
    change_column :parts, :html_info_path, :text
    change_column :parts, :text_info_path, :text
  end

  def down
  end
end
