class AddItemPageToDocumentsPart < ActiveRecord::Migration
  def change
    add_column :parts, :documents_item_page_id, :integer
  end
end
