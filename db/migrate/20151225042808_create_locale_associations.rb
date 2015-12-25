class CreateLocaleAssociations < ActiveRecord::Migration
  def change
    create_table :locale_associations do |t|
      t.belongs_to :site
      t.timestamps
    end
  end
end
