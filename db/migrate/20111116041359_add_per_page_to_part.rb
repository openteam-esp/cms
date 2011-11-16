class AddPerPageToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_per_page, :integer
  end
end
