class RenameUploadsToInodes < ActiveRecord::Migration
  def change
    rename_table :uploads, :inodes
  end
end
