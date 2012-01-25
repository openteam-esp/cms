class AddContextIdToDocumentPart < ActiveRecord::Migration
  def change
    add_column :parts, :documents_context_id, :integer
  end
end
