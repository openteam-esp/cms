class AddDocumentsKindToPart < ActiveRecord::Migration
  def change
    add_column :parts, :documents_kind, :string
  end
end
