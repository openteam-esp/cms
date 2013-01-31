class AddIndexOnPageIdToParts < ActiveRecord::Migration
  def change
    add_index :parts, :node_id
  end
end
