class YoutubeCommentsPart < Part
  def comments
    request_hashie.feed.entry.map do |entry|
      {
        'content'   => content(entry),
        'published' => published(entry),
        'author'    => author(entry)
      }
    end
  end

  private
    def api_comments_url
      params = 'alt=json&v=2'

      "#{api_url}/videos/#{video_id}/comments?#{params}"
    end

    def request
      @request ||= Curl::Easy.perform(api_comments_url) do |curl|
        curl.headers['Accept'] = 'application/json'
      end
    end

    def request_json
      @request_json ||= ActiveSupport::JSON.decode(request.body_str)
    end

    def request_hashie
      @request_hashie ||= Hashie::Mash.new(request_json)
    end

    def content(entry)
      entry.content.send(:$t)
    end

    def published(entry)
      entry.published.send(:$t).to_datetime
    end

    def user_url(username)
      "http://www.youtube.com/user/#{username}"
    end

    def author(entry)
      username = entry.author.first.name.send(:$t)

      {
        'username' => username,
        'profile_url' => user_url(username)
      }
    end
end
