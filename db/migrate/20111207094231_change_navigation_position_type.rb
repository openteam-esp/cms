class ChangeNavigationPositionType < ActiveRecord::Migration
  def up
    change_column :nodes, :navigation_position, :float
  end

  def down
    change_column :nodes, :navigation_position, :integer
  end
end
