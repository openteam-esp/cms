class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :title
      t.references :site_settings

      t.timestamps
    end
    add_index :templates, :site_settings_id
  end
end
