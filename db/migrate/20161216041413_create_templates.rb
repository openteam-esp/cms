class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :title
      t.references :setup

      t.timestamps
    end
    add_index :templates, :setup_id
  end
end
