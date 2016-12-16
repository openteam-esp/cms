class CreatePartTemplates < ActiveRecord::Migration
  def change
    create_table :part_templates do |t|
      t.string :title
      t.text :values
      t.references :setup

      t.timestamps
    end
    add_index :part_templates, :setup_id
  end
end
