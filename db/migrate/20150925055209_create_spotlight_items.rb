class CreateSpotlightItems < ActiveRecord::Migration
  def change
    create_table :spotlight_items do |t|
      t.text :url
      t.integer :position
      t.references :spotlight_part

      t.timestamps
    end
    add_index :spotlight_items, :spotlight_part_id
  end
end
