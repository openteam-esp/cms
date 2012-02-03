class YoutubePlaylistPart < Part
  validates_presence_of :youtube_playlist_id

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    entries
  end

  private
    def youtube_api_url
      'http://gdata.youtube.com/feeds/api'
    end

    def youtube_playlist_url
      params = 'v=2&alt=json'

      "#{youtube_api_url}/playlists/#{youtube_playlist_id}?#{params}"
    end

    def request
      @request ||= Curl::Easy.perform(youtube_playlist_url) do |curl|
        curl.headers['Accept'] = 'application/json'
      end
    end

    def request_json
      @request_body ||= ActiveSupport::JSON.decode(request.body_str)
    end

    def request_hashie
      @request_hashie ||= Hashie::Mash.new(request_json)
    end

    def video_title(entry)
      entry.title.send(:$t)
    end

    def video_id(entry)
      href_regex = /http:\/\/gdata\.youtube\.com\/feeds\/api\/videos\/(.*)\/responses\?v=2/

      href = entry.link.select { |h| h.href.match(href_regex) }.first.href
      fragments = href.split('/')

      fragments[fragments.size - 2]
    end

    def video_url(video_id)
      params = 'autoplay=1&hd=1'

      "http://www.youtube.com/v/#{video_id}?#{params}"
    end

    def video_thumb(video_id)
      #"http://img.youtube.com/vi/#{video_id}/default.jpg"
      "http://img.youtube.com/vi/#{video_id}/0.jpg"
    end

    def entries
      request_hashie.feed.entry.map do |e|
        video_id = video_id(e)

        {
          :video => {
            :title => video_title(e),
            :url => video_url(video_id),
            :thumb => video_thumb(video_id)
          }
        }
      end
    end
end
