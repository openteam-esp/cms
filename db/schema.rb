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

ActiveRecord::Schema.define(:version => 20180628090333) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "gallery_pictures", :force => true do |t|
    t.integer  "gallery_part_id"
    t.text     "description"
    t.text     "picture_url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "position"
  end

  create_table "grouping_items", :force => true do |t|
    t.string   "title"
    t.string   "group"
    t.integer  "navigation_part_id"
    t.integer  "position"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "locale_associations", :force => true do |t|
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "metas", :force => true do |t|
    t.text     "description"
    t.text     "keywords"
    t.string   "url"
    t.text     "image_meta"
    t.text     "og_title"
    t.text     "og_description"
    t.string   "og_type"
    t.string   "og_locale"
    t.string   "og_locale_alternate"
    t.string   "og_site_name"
    t.string   "twitter_card"
    t.string   "twitter_site"
    t.string   "twitter_creator"
    t.string   "twitter_title"
    t.text     "twitter_description"
    t.string   "twitter_domain"
    t.integer  "node_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_url"
  end

  add_index "metas", ["node_id"], :name => "index_metas_on_metable_id"

  create_table "news_collection_items", :force => true do |t|
    t.string   "title"
    t.integer  "node_id"
    t.integer  "news_collection_part_id"
    t.integer  "count"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "position"
    t.boolean  "random"
    t.integer  "period_for_random"
  end

  add_index "news_collection_items", ["news_collection_part_id"], :name => "index_news_collection_items_on_news_collection_part_id"
  add_index "news_collection_items", ["node_id"], :name => "index_news_collection_items_on_node_id"

  create_table "nodes", :force => true do |t|
    t.string   "slug"
    t.text     "title"
    t.string   "ancestry"
    t.string   "type"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.text     "route"
    t.string   "template"
    t.string   "client_url"
    t.boolean  "in_navigation"
    t.string   "navigation_group"
    t.integer  "navigation_position"
    t.text     "navigation_title"
    t.integer  "ancestry_depth",        :default => 0
    t.integer  "page_for_redirect_id"
    t.string   "weight"
    t.text     "external_link"
    t.text     "alternative_title"
    t.integer  "locale_association_id"
  end

  create_table "part_templates", :force => true do |t|
    t.string   "title"
    t.text     "values"
    t.integer  "setup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "part_templates", ["setup_id"], :name => "index_part_templates_on_setup_id"

  create_table "parts", :force => true do |t|
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "region"
    t.string   "type"
    t.integer  "node_id"
    t.integer  "navigation_end_level"
    t.integer  "navigation_from_id"
    t.integer  "navigation_default_level"
    t.string   "news_channel"
    t.integer  "news_per_page"
    t.boolean  "news_paginated"
    t.integer  "news_item_page_id"
    t.integer  "blue_pages_category_id"
    t.string   "appeal_section_slug"
    t.string   "navigation_group"
    t.text     "title"
    t.text     "html_info_path"
    t.integer  "blue_pages_item_page_id"
    t.string   "documents_kind"
    t.integer  "documents_item_page_id"
    t.boolean  "documents_paginated"
    t.integer  "documents_per_page"
    t.integer  "news_height"
    t.integer  "news_width"
    t.integer  "news_mlt_count"
    t.integer  "news_mlt_width"
    t.integer  "news_mlt_height"
    t.string   "template"
    t.text     "text_info_path"
    t.string   "news_event_entry"
    t.integer  "blue_pages_expand"
    t.string   "documents_contexts"
    t.integer  "search_per_page"
    t.integer  "organization_list_category_id"
    t.integer  "organization_list_per_page"
    t.integer  "organization_list_item_page_id"
    t.integer  "directory_presentation_id"
    t.integer  "directory_presentation_item_page_id"
    t.integer  "directory_presentation_photo_width"
    t.integer  "directory_presentation_photo_height"
    t.string   "directory_presentation_photo_crop_kind"
    t.integer  "directory_post_photo_width"
    t.integer  "directory_post_photo_height"
    t.string   "directory_post_photo_crop_kind"
    t.integer  "directory_post_post_id"
    t.integer  "gpo_project_list_chair_id"
    t.string   "streams_degree"
    t.string   "provided_disciplines_subdepartment"
    t.integer  "news_mlt_number_of_months",              :default => 1
    t.integer  "directory_subdivision_id"
    t.integer  "directory_depth"
    t.integer  "priem_context_id"
    t.string   "priem_context_kind"
    t.string   "priem_kinds"
    t.string   "priem_forms"
    t.integer  "storage_directory_id"
    t.string   "storage_directory_name"
    t.integer  "storage_directory_depth"
    t.boolean  "directory_only_pps"
    t.boolean  "without_chief"
  end

  add_index "parts", ["node_id"], :name => "index_parts_on_node_id"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "role"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "permissions", ["user_id", "role", "context_id", "context_type"], :name => "by_user_and_role_and_context"

  create_table "promo_slides", :force => true do |t|
    t.string   "title"
    t.text     "url"
    t.text     "video_url"
    t.text     "annotation"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_url"
    t.integer  "promo_part_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "target_blank"
  end

  add_index "promo_slides", ["promo_part_id"], :name => "index_promo_slides_on_promo_part_id"

  create_table "regions", :force => true do |t|
    t.string   "title"
    t.boolean  "required",     :default => false
    t.boolean  "configurable", :default => false
    t.boolean  "indexable",    :default => false
    t.integer  "template_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "position"
  end

  add_index "regions", ["template_id"], :name => "index_regions_on_template_id"

  create_table "setups", :force => true do |t|
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "setups", ["site_id"], :name => "index_setups_on_site_id"

  create_table "spotlight_item_photos", :force => true do |t|
    t.integer  "spotlight_item_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "photo_url"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "spotlight_items", :force => true do |t|
    t.text     "url"
    t.integer  "position"
    t.integer  "spotlight_part_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "kind"
    t.string   "title"
    t.text     "annotation"
    t.string   "legend"
    t.datetime "since"
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.boolean  "target_url"
  end

  add_index "spotlight_items", ["spotlight_part_id"], :name => "index_spotlight_items_on_spotlight_part_id"

  create_table "temperature_items", :force => true do |t|
    t.integer  "temperature_part_id"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "position"
  end

  add_index "temperature_items", ["temperature_part_id"], :name => "index_temperature_items_on_temperature_part_id"

  create_table "templates", :force => true do |t|
    t.string   "title"
    t.integer  "setup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  add_index "templates", ["setup_id"], :name => "index_templates_on_setup_id"

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
