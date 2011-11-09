class RemovePageIdFromPart < ActiveRecord::Migration
  def up
    remove_column :parts, :page_id
  end

  def down
    add_column :parts, :page_id, :integer
  end
end
