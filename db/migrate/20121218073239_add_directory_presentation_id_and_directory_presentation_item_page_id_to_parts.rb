class AddDirectoryPresentationIdAndDirectoryPresentationItemPageIdToParts < ActiveRecord::Migration
  def change
    add_column :parts, :directory_presentation_id, :integer
    add_column :parts, :directory_presentation_item_page_id, :integer
  end
end
