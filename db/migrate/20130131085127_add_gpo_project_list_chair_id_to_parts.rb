class AddGpoProjectListChairIdToParts < ActiveRecord::Migration
  def change
    add_column :parts, :gpo_project_list_chair_id, :integer
  end
end
