class AddNewsItemPageIdToNewListParts < ActiveRecord::Migration
  def change
    add_column :parts, :news_item_page_id, :integer
  end
end
