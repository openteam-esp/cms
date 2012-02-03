class AddYoutubePlaylistItemPageIdToPart < ActiveRecord::Migration
  def change
    add_column :parts, :youtube_playlist_item_page_id, :integer

  end
end
