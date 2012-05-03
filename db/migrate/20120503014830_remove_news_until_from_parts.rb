class RemoveNewsUntilFromParts < ActiveRecord::Migration
  def up
    remove_column :parts, :news_until
  end

  def down
    add_column :parts, :news_until, :date
  end
end
