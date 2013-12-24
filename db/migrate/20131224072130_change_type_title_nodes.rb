class ChangeTypeTitleNodes < ActiveRecord::Migration
  def up
    change_column :nodes, :title, :text
    change_column :nodes, :navigation_title, :text
  end

  def down
    change_column :nodes, :title, :string
    change_column :nodes, :navigation_title, :string
  end
end
