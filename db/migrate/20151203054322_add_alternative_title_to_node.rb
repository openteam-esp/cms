class AddAlternativeTitleToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :alternative_title, :text
  end
end
