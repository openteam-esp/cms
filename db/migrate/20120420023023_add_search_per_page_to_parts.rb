class AddSearchPerPageToParts < ActiveRecord::Migration
  def change
    add_column :parts, :search_per_page, :integer

  end
end
