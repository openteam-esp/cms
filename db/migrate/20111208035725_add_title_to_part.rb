class AddTitleToPart < ActiveRecord::Migration
  def change
    add_column :parts, :title, :string
  end
end
