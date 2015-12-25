class AddBelongsToLocaleAssociationToPages < ActiveRecord::Migration
  def change
    add_column :nodes, :locale_association_id, :integer
  end
end
