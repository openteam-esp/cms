class AddWeightToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :weight, :string

  end
end
