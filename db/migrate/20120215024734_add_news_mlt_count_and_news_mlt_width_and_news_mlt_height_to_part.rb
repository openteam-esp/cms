class AddNewsMltCountAndNewsMltWidthAndNewsMltHeightToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_mlt_count, :integer

    add_column :parts, :news_mlt_width, :integer

    add_column :parts, :news_mlt_height, :integer

  end
end
