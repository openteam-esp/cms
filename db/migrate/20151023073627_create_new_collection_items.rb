class CreateNewCollectionItems < ActiveRecord::Migration
  def change
    create_table :news_collection_items do |t|
      t.string :title
      t.references :node
      t.references :news_collection_part
      t.integer :count

      t.timestamps
    end
    add_index :news_collection_items, :node_id
    add_index :news_collection_items, :news_collection_part_id
  end
end
