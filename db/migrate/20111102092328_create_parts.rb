class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.references :content
      t.references :page
      t.references :region

      t.timestamps
    end
    add_index :parts, :content_id
    add_index :parts, :page_id
    add_index :parts, :region_id
  end
end
