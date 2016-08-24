class AddStorageDirectoryIdStorageDirectoryNameAndStorageDirectoryDepthToPart < ActiveRecord::Migration
  def change
    add_column :parts, :storage_directory_id, :integer
    add_column :parts, :storage_directory_name, :string
    add_column :parts, :storage_directory_depth, :integer
  end
end
