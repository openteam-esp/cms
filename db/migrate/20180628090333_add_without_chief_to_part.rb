class AddWithoutChiefToPart < ActiveRecord::Migration
  def change
    add_column :parts, :without_chief, :boolean
  end
end
