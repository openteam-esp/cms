class AddFolderIdToInodes < ActiveRecord::Migration
  def change
    add_column :inodes, :folder_id, :string
    add_index :inodes, :folder_id
    add_index :inodes, :type
  end
end
