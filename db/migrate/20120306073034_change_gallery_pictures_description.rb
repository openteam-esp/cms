class ChangeGalleryPicturesDescription < ActiveRecord::Migration
  def up
    change_column :gallery_pictures, :description, :text, :limit => nil
  end

  def down
    change_column :gallery_pictures, :description, :string
  end
end
