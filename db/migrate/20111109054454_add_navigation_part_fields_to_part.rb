class AddNavigationPartFieldsToPart < ActiveRecord::Migration
  def change
    add_column :parts, :node_id, :integer
    add_column :parts, :descendants_level, :integer
    add_column :parts, :selected_descendants_level, :integer
  end
end
