class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :title
      t.boolean :required, default: false
      t.boolean :configurable, default: false
      t.boolean :indexable, default: false
      t.references :template

      t.timestamps
    end
    add_index :regions, :template_id
  end
end
