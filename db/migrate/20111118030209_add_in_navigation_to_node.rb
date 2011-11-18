class AddInNavigationToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :in_navigation, :boolean
  end
end
