class RestorePermissions < ActiveRecord::Migration
  def up
    remove_column :nodes, :context_id

    drop_table :contexts

    Permission.update_all(:context_id => nil, :context_type => nil)
    Permission.find_by_id(5).try :update_attributes, :context => Node.find_by_id(437)
    Permission.find_by_id(6).try :update_attributes, :context => Node.find_by_id(702)
  end

  def down
    add_column :nodes, :context_id, :integer

    create_table "contexts", :force => true do |t|
      t.string   "title"
      t.string   "ancestry"
      t.string   "weight"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "contexts", ["ancestry"], :name => "index_contexts_on_ancestry"
    add_index "contexts", ["weight"], :name => "index_contexts_on_weight"

  end
end
