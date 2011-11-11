class AddDefaultLevelToNavigationPart < ActiveRecord::Migration
  def change
    add_column :parts, :navigation_default_level, :integer
  end
end
