class AddPageForRedirectIdToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :page_for_redirect_id, :integer

  end
end
