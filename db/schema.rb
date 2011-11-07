# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111107024713) do

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "ancestry"
    t.integer  "template_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", :force => true do |t|
    t.integer  "content_id"
    t.integer  "page_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["content_id"], :name => "index_parts_on_content_id"
  add_index "parts", ["page_id"], :name => "index_parts_on_page_id"
  add_index "parts", ["region_id"], :name => "index_parts_on_region_id"

  create_table "regions", :force => true do |t|
    t.string   "title"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "regions", ["template_id"], :name => "index_regions_on_template_id"

  create_table "templates", :force => true do |t|
    t.string   "title"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "templates", ["site_id"], :name => "index_templates_on_site_id"

end
