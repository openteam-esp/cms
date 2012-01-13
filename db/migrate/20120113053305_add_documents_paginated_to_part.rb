class AddDocumentsPaginatedToPart < ActiveRecord::Migration
  def change
    add_column :parts, :documents_paginated, :boolean
    add_column :parts, :documents_per_page, :integer
  end
end
