class AddEventEntryToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_event_entry, :string

  end
end
