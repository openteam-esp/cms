class DropContentTable < ActiveRecord::Migration
  def up
    drop_table :contents
  end

  def down
    create_table :contents  do |t|
      t.string   :title
      t.text     :body
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
