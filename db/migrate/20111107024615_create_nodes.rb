class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :slug
      t.string :title
      t.string :ancestry
      t.integer :template_id
      t.string :type

      t.timestamps
    end
  end
end
