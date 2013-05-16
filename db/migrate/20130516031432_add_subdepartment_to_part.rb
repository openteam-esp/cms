class AddSubdepartmentToPart < ActiveRecord::Migration
  def change
    add_column :parts, :provided_disciplines_subdepartment, :string
  end
end
