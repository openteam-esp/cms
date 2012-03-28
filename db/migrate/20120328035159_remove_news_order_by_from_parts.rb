class RemoveNewsOrderByFromParts < ActiveRecord::Migration
  def up
    remove_column :parts, :news_order_by
  end

  def down
    add_column :parts, :news_order_by, :string
  end
end
