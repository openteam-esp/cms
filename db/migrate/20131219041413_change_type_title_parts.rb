class ChangeTypeTitleParts < ActiveRecord::Migration
  def up
    change_column :parts, :title, :text
  end

  def down
    change_column :parts, :title, :string
  end
end
