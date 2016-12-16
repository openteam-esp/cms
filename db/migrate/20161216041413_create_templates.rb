class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :title
      t.references :site_setting

      t.timestamps
    end
    add_index :templates, :site_setting_id
  end
end
