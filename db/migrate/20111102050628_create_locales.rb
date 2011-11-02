class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :title
      t.references :site

      t.timestamps
    end
    add_index :locales, :site_id
  end
end
