class RemoveYoutubeFields < ActiveRecord::Migration
  def up
    remove_column :parts, :youtube_resource_id
    remove_column :parts, :youtube_item_page_id
    remove_column :parts, :youtube_video_resource_id
    remove_column :parts, :youtube_resource_kind
    remove_column :parts, :youtube_per_page
    remove_column :parts, :youtube_paginated
    remove_column :parts, :youtube_video_resource_kind
    remove_column :parts, :youtube_video_with_related
    remove_column :parts, :youtube_video_related_count
    remove_column :parts, :youtube_video_width
    remove_column :parts, :youtube_video_height
  end

  def down
    add_column :parts, :youtube_resource_id, :string
    add_column :parts, :youtube_item_page_id, :integer
    add_column :parts, :youtube_video_resource_id, :string
    add_column :parts, :youtube_resource_kind, :string
    add_column :parts, :youtube_per_page, :integer
    add_column :parts, :youtube_paginated, :boolean
    add_column :parts, :youtube_video_resource_kind, :string
    add_column :parts, :youtube_video_with_related, :boolean
    add_column :parts, :youtube_video_related_count, :integer
    add_column :parts, :youtube_video_width, :integer
    add_column :parts, :youtube_video_height, :integer
  end
end
