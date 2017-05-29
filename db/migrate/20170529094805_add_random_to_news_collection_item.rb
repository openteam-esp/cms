class AddRandomToNewsCollectionItem < ActiveRecord::Migration
  def change
    add_column :news_collection_items, :random, :boolean
  end
end
