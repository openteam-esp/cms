class AddInfoPathToPart < ActiveRecord::Migration
  def change
    add_column :parts, :html_info_path, :string
  end
end
