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

ActiveRecord::Schema.define(:version => 20120323040652) do

  create_table "contexts", :force => true do |t|
    t.string   "title"
    t.string   "ancestry"
    t.string   "weight"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contexts", ["ancestry"], :name => "index_contexts_on_ancestry"
  add_index "contexts", ["weight"], :name => "index_contexts_on_weight"

  create_table "gallery_pictures", :force => true do |t|
    t.integer  "gallery_part_id"
    t.text     "description"
    t.string   "picture_url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "nodes", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "ancestry"
    t.string   "type"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.text     "route"
    t.string   "template"
    t.string   "client_url"
    t.boolean  "in_navigation"
    t.string   "navigation_group"
    t.integer  "navigation_position"
    t.string   "navigation_title"
    t.integer  "ancestry_depth",       :default => 0
    t.integer  "page_for_redirect_id"
    t.string   "weight"
    t.integer  "context_id"
  end

  create_table "parts", :force => true do |t|
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "region"
    t.string   "type"
    t.integer  "node_id"
    t.integer  "navigation_end_level"
    t.integer  "navigation_from_id"
    t.integer  "navigation_default_level"
    t.string   "news_channel"
    t.string   "news_order_by"
    t.date     "news_until"
    t.integer  "news_per_page"
    t.boolean  "news_paginated"
    t.integer  "news_item_page_id"
    t.integer  "blue_pages_category_id"
    t.string   "appeal_section_slug"
    t.boolean  "blue_pages_expand"
    t.string   "navigation_group"
    t.string   "title"
    t.string   "html_info_path"
    t.integer  "blue_pages_item_page_id"
    t.string   "documents_kind"
    t.integer  "documents_item_page_id"
    t.boolean  "documents_paginated"
    t.integer  "documents_per_page"
    t.integer  "documents_context_id"
    t.string   "youtube_resource_id"
    t.integer  "youtube_item_page_id"
    t.string   "youtube_video_resource_id"
    t.string   "youtube_resource_kind"
    t.integer  "youtube_per_page"
    t.boolean  "youtube_paginated"
    t.string   "youtube_video_resource_kind"
    t.integer  "news_height"
    t.integer  "news_width"
    t.integer  "news_mlt_count"
    t.integer  "news_mlt_width"
    t.integer  "news_mlt_height"
    t.string   "template"
    t.boolean  "youtube_video_with_related"
    t.integer  "youtube_video_related_count"
    t.integer  "youtube_video_width"
    t.integer  "youtube_video_height"
    t.string   "text_info_path"
    t.string   "news_event_entry"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "role"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "permissions", ["user_id", "role", "context_id", "context_type"], :name => "by_user_and_role_and_context"

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.text     "name"
    t.text     "email"
    t.text     "nickname"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "location"
    t.text     "description"
    t.text     "image"
    t.text     "phone"
    t.text     "urls"
    t.text     "raw_info"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
