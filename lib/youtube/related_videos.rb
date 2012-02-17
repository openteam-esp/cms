class Youtube::RelatedVideos < Youtube::Resource
  attr_reader :video

  def initialize(video)
    @video = video
  end

  private
    def request_params
      'v=2&alt=json'.tap do |string|
        string << "&author=#{video.author}"
        string << "&max-results=#{max_results}" if max_results
        string << "&start-index=#{start_index}" if start_index
      end
    end

    def api_resource_url
      "#{api_url}/videos/#{video.id}/related"
    end
end

