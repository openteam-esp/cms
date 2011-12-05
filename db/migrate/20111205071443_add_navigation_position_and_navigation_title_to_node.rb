class AddNavigationPositionAndNavigationTitleToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :navigation_position, :integer
    add_column :nodes, :navigation_title, :string
  end
end
