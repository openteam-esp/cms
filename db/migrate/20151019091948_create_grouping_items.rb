class CreateGroupingItems < ActiveRecord::Migration
  def change
    create_table :grouping_items do |t|
      t.string     :title
      t.string     :group
      t.belongs_to :navigation_part
      t.integer    :position, :default => nil

      t.timestamps
    end
  end
end
