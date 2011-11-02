class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.references :locale
      t.string :ancestry

      t.timestamps
    end
    add_index :pages, :locale_id
  end
end
