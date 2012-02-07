class YoutubePlaylistPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :youtube_playlist_item_page_id

  validates_presence_of :youtube_playlist_id

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :entries, :to => :youtube_playlist

  def content
    entries
  end

  private
    def youtube_playlist
      Youtube::Playlist.new(:id => youtube_playlist_id, :item_page => item_page)
    end
end
