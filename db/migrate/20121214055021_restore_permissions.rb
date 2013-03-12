class Context < ActiveRecord::Base
end

class Node < ActiveRecord::Base
  belongs_to :context
end

class RestorePermissions < ActiveRecord::Migration
  def up
    Permission.all.each do |permission|
      permission.update_attribute :context, Site.find_by_context_id(permission.context_id)
    end

    drop_table :contexts

    remove_column :nodes, :context_id
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
