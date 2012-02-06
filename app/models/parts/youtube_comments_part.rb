class YoutubeCommentsPart < Part
  attr_accessor :node, :params

  def comments
    {}.tap do |hash|
      entries = request_hashie.feed.entry.map do |entry|
        {
          'content'   => content(entry),
          'published' => published(entry),
          'author'    => author(entry)
        }
      end

      hash['entries'] = entries
      hash['pagination'] = pagination
    end
  end

  private
    def video_id
      params['id']
    end

    def start_index
      params['start-index'] || 1
    end

    def max_results
      params['max-results'] || 10
    end

    def api_url
      'http://gdata.youtube.com/feeds/api'
    end

    def api_comments_url
      params = "alt=json&v=2&start-index=#{start_index}&max-results=#{max_results}"

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

    def comments_page_path(start_index)
      "#{node.route_without_site}?parts_params[youtube_video][id]=#{video_id}&parts_params[youtube_video][only_comments]=true&parts_params[youtube_video][start-index]=#{start_index}&parts_params[youtube_video][max-results]=#{max_results}"
    end

    def total_pages
      request_hashie.feed.send('openSearch$totalResults'.to_sym).send(:$t).to_i
    end

    def current_page
      start_index.to_i / max_results.to_i
    end

    def pagination
      results = []

      (0..10).each do |i|
        start_index = (max_results.to_i * i) + 1

        hash = { 'number' => (i + 1).to_s, 'url' => comments_page_path(start_index) }
        hash.merge!('current' => true) if current_page == i

        results << hash
      end

      results
    end
end
