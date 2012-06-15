class AddFieldsForOrganizationListPart < ActiveRecord::Migration
  def change
    add_column :parts, :organization_list_category_id, :integer
    add_column :parts, :organization_list_per_page, :integer
    add_column :parts, :organization_list_item_page_id, :integer
  end
end
