class AddYoutubeVideoPlaylistIdToParts < ActiveRecord::Migration
  def change
    add_column :parts, :youtube_video_playlist_id, :string

  end
end
