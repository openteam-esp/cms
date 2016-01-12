class AddDirectoryPartFieldsToPart < ActiveRecord::Migration
  def change
    add_column :parts, :directory_subdivision_id, :integer
    add_column :parts, :directory_depth, :integer
  end
end
