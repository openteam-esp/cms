class CreateTemperatureItems < ActiveRecord::Migration
  def change
    create_table :temperature_items do |t|
      t.references :temperature_part
      t.string :title
      t.string :url

      t.timestamps
    end
    add_index :temperature_items, :temperature_part_id
  end
end
