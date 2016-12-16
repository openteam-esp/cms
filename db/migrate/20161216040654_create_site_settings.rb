class CreateSiteSettings < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.references :site

      t.timestamps
    end
    add_index :setups, :site_id
  end
end
