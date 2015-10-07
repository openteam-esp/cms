class AddFieldsToSpotlightItems < ActiveRecord::Migration
  def change
    add_column :spotlight_items, :kind, :string
    add_column :spotlight_items, :title, :string
    add_column :spotlight_items, :annotation, :text
    add_column :spotlight_items, :legend, :string
    add_column :spotlight_items, :since, :datetime
    add_column :spotlight_items, :starts_on, :datetime
    add_column :spotlight_items, :ends_on, :datetime
  end
end
