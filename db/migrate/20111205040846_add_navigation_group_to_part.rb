class AddNavigationGroupToPart < ActiveRecord::Migration
  def change
    add_column :parts, :navigation_group, :string
  end
end
