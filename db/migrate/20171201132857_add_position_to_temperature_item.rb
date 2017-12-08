class AddPositionToTemperatureItem < ActiveRecord::Migration
  def change
    add_column :temperature_items, :position, :integer
  end
end
