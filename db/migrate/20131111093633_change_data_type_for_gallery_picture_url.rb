class ChangeDataTypeForGalleryPictureUrl < ActiveRecord::Migration
  def up
    change_table :gallery_pictures do |t|
      t.change :picture_url, :text
    end
  end

  def down
    change_table :gallery_pictures do |t|
      t.change :picture_url, :string
    end
  end
end
