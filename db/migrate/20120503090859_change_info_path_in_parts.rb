class ChangeInfoPathInParts < ActiveRecord::Migration
  def up
    change_column :parts, :html_info_path, :text, :limit => nil
    change_column :parts, :text_info_path, :text, :limit => nil
  end

  def down
  end
end
