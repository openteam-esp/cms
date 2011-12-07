class DropInodes < ActiveRecord::Migration
  def up
    drop_table :inodes
  end

  def down
    create_table :inodes do |t|
      t.string :type
      t.string :file_name
      t.string :file_mime_type
      t.string :file_size
      t.string :file_uid
      t.string :folder_id
      t.string :ancestry

      t.timestamps
    end
  end
end
