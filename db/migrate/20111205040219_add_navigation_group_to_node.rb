class AddNavigationGroupToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :navigation_group, :string
  end
end
