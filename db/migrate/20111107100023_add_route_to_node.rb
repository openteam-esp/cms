class AddRouteToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :route, :text
  end
end
