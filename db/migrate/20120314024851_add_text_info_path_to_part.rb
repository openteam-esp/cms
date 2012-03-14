class AddTextInfoPathToPart < ActiveRecord::Migration
  def change
    add_column :parts, :text_info_path, :string
  end
end
