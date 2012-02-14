class AddWidthAndHeightToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_height, :integer
    add_column :parts, :news_width, :integer
  end
end
