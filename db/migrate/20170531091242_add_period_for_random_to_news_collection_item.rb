class AddPeriodForRandomToNewsCollectionItem < ActiveRecord::Migration
  def change
    add_column :news_collection_items, :period_for_random, :integer
  end
end
