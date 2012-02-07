class YoutubePart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :youtube_item_page_id

  validates_presence_of :youtube_kind, :youtube_object_id

  has_enums

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :entries, :to => :youtube_object, :prefix => true

  def content
    youtube_object_entries
  end

  private
    def youtube_object
      youtube_kind_playlist? ? Youtube::Playlist.new(object_attributes) : Youtube::User.new(object_attributes)
    end

    def object_attributes
      { :id => youtube_object_id, :item_page => item_page }
    end
end
