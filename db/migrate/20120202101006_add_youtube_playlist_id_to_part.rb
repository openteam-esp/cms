class AddYoutubePlaylistIdToPart < ActiveRecord::Migration
  def change
    add_column :parts, :youtube_playlist_id, :string

  end
end
