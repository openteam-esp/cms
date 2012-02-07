class YoutubePart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :youtube_item_page_id

  validates_presence_of :youtube_kind, :youtube_object_id

  has_enums

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :entries, :to => :youtube_playlist, :prefix => true

  def content
    youtube_playlist_entries
  end

  private
    def youtube_playlist
      Youtube::Playlist.new(:id => youtube_playlist_id, :item_page => item_page)
    end
end
