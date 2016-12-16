class CreateSiteSettings < ActiveRecord::Migration
  def change
    create_table :site_settings do |t|
      t.references :site

      t.timestamps
    end
    add_index :site_settings, :site_id
  end
end
