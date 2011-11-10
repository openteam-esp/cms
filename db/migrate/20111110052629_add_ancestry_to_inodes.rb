class AddAncestryToInodes < ActiveRecord::Migration
  def change
    add_column :inodes, :ancestry, :string
    add_index :inodes, :ancestry
  end
end
