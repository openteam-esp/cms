class AddFieldsForYoutubeParts < ActiveRecord::Migration
  def change
    add_column :parts, :youtube_per_page, :integer
    add_column :parts, :youtube_paginated, :boolean
  end
end
