class AddClientUrlToSite < ActiveRecord::Migration
  def change
    add_column :nodes, :client_url, :string
  end
end
