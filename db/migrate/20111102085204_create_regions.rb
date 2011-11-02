class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :title
      t.references :template

      t.timestamps
    end
    add_index :regions, :template_id
  end
end
