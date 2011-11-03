class RenameLocaleTitleToLocale < ActiveRecord::Migration
  def change
    rename_column :locales, :title, :locale
  end
end
