class CreateSpotlightItemPhotos < ActiveRecord::Migration
  def change
    create_table :spotlight_item_photos do |t|
      t.belongs_to :spotlight_item, index: true
      t.attachment :photo

      t.timestamps
    end
  end
end
