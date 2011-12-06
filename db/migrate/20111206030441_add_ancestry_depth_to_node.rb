class AddAncestryDepthToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :ancestry_depth, :integer, :default => 0
  end
end
