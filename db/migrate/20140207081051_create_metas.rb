class CreateMetas < ActiveRecord::Migration
  def change
    create_table :metas do |t|
      t.text        :description
      t.text        :keywords
      t.string      :url
      t.text        :image_meta
      t.text        :og_title
      t.text        :og_description
      t.string      :og_type
      t.string      :og_locale
      t.string      :og_locale_alternate
      t.string      :og_site_name
      t.string      :twitter_card
      t.string      :twitter_site
      t.string      :twitter_creator
      t.string      :twitter_title
      t.text        :twitter_description
      t.string      :twitter_domain
      t.references  :metable, :polymorphic => true

      t.timestamps
    end
    add_attachment  :metas, :image
    add_index :metas, :metable_id
  end
end
