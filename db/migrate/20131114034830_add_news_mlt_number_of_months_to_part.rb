class AddNewsMltNumberOfMonthsToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_mlt_number_of_months, :integer, :default => 1
  end
end
