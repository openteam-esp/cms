class DropSitesLocalesAndPages < ActiveRecord::Migration
  def up
    drop_table :locales
    drop_table :pages
    drop_table :sites
  end

  def down
    create_table "locales", :force => true do |t|
      t.string   "locale"
      t.integer  "site_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "locales", ["site_id"], :name => "index_locales_on_site_id"

    create_table "pages", :force => true do |t|
      t.string   "title"
      t.integer  "locale_id"
      t.string   "ancestry"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "template_id"
      t.string   "slug"
    end
    add_index "pages", ["locale_id"], :name => "index_pages_on_locale_id"
    add_index "pages", ["template_id"], :name => "index_pages_on_template_id"

    create_table "sites", :force => true do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
