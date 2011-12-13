class RemoveHtmlContentIdFromPart < ActiveRecord::Migration
  def up
    remove_column :parts, :html_content_id
  end

  def down
    add_column :parts, :html_content_id, :integer
  end
end
