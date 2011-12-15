class AddBluePagesItemPageIdToParts < ActiveRecord::Migration
  def change
    add_column :parts, :blue_pages_item_page_id, :integer
  end
end
