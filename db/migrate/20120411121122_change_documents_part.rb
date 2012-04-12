class ChangeDocumentsPart < ActiveRecord::Migration
  def up
    remove_column :parts, :documents_context_id
    add_column :parts, :documents_contexts, :string
  end

  def down
    remove_column :parts, :documents_contexts
    add_column :parts, :documents_context_id, :integer
  end
end
