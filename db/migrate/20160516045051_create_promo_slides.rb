class CreatePromoSlides < ActiveRecord::Migration
  def up
    create_table :promo_slides do |t|
      t.string :title
      t.text :url
      t.text :video_url
      t.text :annotation
      t.integer :position
      t.attachment :image
      t.references :promo_part

      t.timestamps
    end
    add_index :promo_slides, :promo_part_id
  end

  def down
    remove_index :promo_slides, :promo_part_id
    drop_table :promo_slides
  end
end
