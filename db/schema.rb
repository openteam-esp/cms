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

ActiveRecord::Schema.define(:version => 20120112043807) do

  create_table "gallery_pictures", :force => true do |t|
    t.integer  "gallery_part_id"
    t.string   "description"
    t.string   "picture_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "ancestry"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "route"
    t.string   "template"
    t.string   "client_url"
    t.boolean  "in_navigation"
    t.string   "navigation_group"
    t.integer  "navigation_position"
    t.string   "navigation_title"
    t.integer  "ancestry_depth",      :default => 0
  end

  create_table "parts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

end
