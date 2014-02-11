class ChangeMetaBelongsTo < ActiveRecord::Migration
  def up
    remove_column :metas, :metable_type
    rename_column :metas, :metable_id, :node_id
  end

  def down
    rename_column :metas, :node_id, :metable_id
    add_column :metas, :metable_type, :string
    Meta.update_all(:metable_type => 'Node')
  end
end
