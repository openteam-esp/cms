class RemoveTemplateAndRegion < ActiveRecord::Migration
  def up
    drop_table :templates
    drop_table :regions

    remove_column :nodes, :template_id
    remove_column :parts, :region_id

    add_column :nodes, :template, :string
    add_column :parts, :region, :string
  end

  def down
    create_table "templates", :force => true do |t|
      t.string   "title"
      t.integer  "site_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end

    add_index "templates", ["site_id"], :name => "index_templates_on_site_id"

    create_table "regions", :force => true do |t|
      t.string   "title"
      t.integer  "template_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end

    add_index "regions", ["template_id"], :name => "index_regions_on_template_id"

    add_column :nodes, :template_id, :integer
    add_column :parts, :region_id, :integer

    remove_column :nodes, :template
    remove_column :parts, :region
  end
end
