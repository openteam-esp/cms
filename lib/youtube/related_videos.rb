class Youtube::RelatedVideos < Youtube::Resource
  attr_reader :video

  def initialize(video)
    @video = video
  end

  private
    def request_params
      'v=2&alt=json'.tap do |string|
        string << "&author=#{video.author}"
        string << "&max-results=#{video.related_videos_max_results}" if video.related_videos_max_results
      end
    end

    def api_resource_url
      p '============================='
      p "#{api_url}/videos/#{video.id}/related?#{request_params}"
      #p "#{api_url}/videos/#{video.id}/related"
    end
end

