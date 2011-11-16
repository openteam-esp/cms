class AddSearchingFieldsToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_order_by, :string
    add_column :parts, :news_until, :date
  end
end
