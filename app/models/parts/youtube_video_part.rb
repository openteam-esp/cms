class YoutubeVideoPart < Part
  validates_presence_of :youtube_video_playlist_id

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :info, :title, :to => :youtube_video

  def content
    info
  end

  def page_title
    title
  end

  private
    def youtube_video
      Youtube::Video.new(:id => params['id'],
                         :playlist_id => youtube_video_playlist_id,
                         :params => params,
                         :node => node)
    end
end
