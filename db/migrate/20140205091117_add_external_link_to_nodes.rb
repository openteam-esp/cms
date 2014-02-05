class AddExternalLinkToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :external_link, :text
  end
end
