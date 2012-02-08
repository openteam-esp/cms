class ChangeFieldsForYoutubeParts < ActiveRecord::Migration
  def up
    rename_column :parts, :youtube_object_id, :youtube_resource_id
    rename_column :parts, :youtube_kind, :youtube_resource_kind
    rename_column :parts, :youtube_video_playlist_id, :youtube_video_resource_id
    add_column :parts, :youtube_video_resource_kind, :string
  end

  def down
    remove_column :parts, :youtube_video_resource_kind
    rename_column :parts, :youtube_video_resource_id, :youtube_video_playlist_id
    rename_column :parts, :youtube_resource_kind, :youtube_kind
    rename_column :parts, :youtube_resource_id, :youtube_object_id
  end
end
