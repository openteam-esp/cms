class AddFieldsForPriemPartToPart < ActiveRecord::Migration
  def change
    add_column :parts, :priem_context_id, :integer
    add_column :parts, :priem_context_kind, :string
    add_column :parts, :priem_kinds, :string
    add_column :parts, :priem_forms, :string
  end
end
