class AddTargetUrlToSpotlightItems < ActiveRecord::Migration
  def change
    add_column :spotlight_items, :target_url, :boolean
  end
end
