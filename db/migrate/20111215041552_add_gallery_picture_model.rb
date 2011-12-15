class AddGalleryPictureModel < ActiveRecord::Migration
  def change
    create_table :gallery_pictures do |t|
      t.integer :gallery_part_id
      t.string :description
      t.string :picture_url

      t.timestamps
    end
  end
end
