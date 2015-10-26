class AddPositionToNewsCollectionItem < ActiveRecord::Migration
  def change
    add_column :news_collection_items, :position, :integer
  end
end
