class AddDirectoryPostPostIdToParts < ActiveRecord::Migration
  def change
    add_column :parts, :directory_post_post_id, :integer
  end
end
