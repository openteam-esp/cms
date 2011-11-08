class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :type
      t.string :file_name
      t.string :file_mime_type
      t.string :file_size
      t.string :file_uid

      t.timestamps
    end
  end
end
