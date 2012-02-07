class ChangeYoutubePartFields < ActiveRecord::Migration
  def up
    rename_column :parts, :youtube_playlist_id, :youtube_object_id
    rename_column :parts, :youtube_playlist_item_page_id, :youtube_item_page_id

    add_column :parts, :youtube_kind, :string
  end

  def down
    remove_column :parts, :youtube_kind

    rename_column :parts, :youtube_item_page_id, :youtube_playlist_item_page_id
    rename_column :parts, :youtube_object_id, :youtube_playlist_id
  end
end
