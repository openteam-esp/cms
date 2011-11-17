class RemoveNewsCountFromPart < ActiveRecord::Migration
  def up
    remove_column :parts, :news_count
  end

  def down
    add_column :parts, :news_count, :integer
  end
end
