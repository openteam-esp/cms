class YoutubeVideoPart < Part
  validates_presence_of :youtube_video_playlist_id

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :info, :title, :to => :youtube_video, :prefix => true

  def content
    youtube_video_info
  end

  def page_title
    youtube_video_title
  end

  private
    def youtube_video
      Youtube::Video.new(:id => params['id'],
                         :playlist_id => youtube_video_playlist_id,
                         :params => params,
                         :node => node)
    end
end
