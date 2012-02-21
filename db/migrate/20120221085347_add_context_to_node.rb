class AddContextToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :context_id, :integer

  end
end
