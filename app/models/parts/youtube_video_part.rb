class YoutubeVideoPart < Part
  validates_presence_of :youtube_video_resource_id, :youtube_video_resource_kind

  has_enums

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :info, :title, :to => :youtube_video, :prefix => true

  def content
    youtube_video_info
  end

  def page_title
    youtube_video_title unless youtube_video_info.empty?
  end

  private
    def youtube_video
      Youtube::Video.new(:id => params['id'],
                         :resource_id => youtube_video_resource_id,
                         :resource_kind => youtube_video_resource_kind,
                         :params => params,
                         :node => node)
    end
end
