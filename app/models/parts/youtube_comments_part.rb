class YoutubeCommentsPart < Part
  attr_accessor :node, :params

  def comments
    {}.tap do |hash|
      entries = comments_hashie.feed.entry.map do |entry|
        {
          'content'   => comment_content(entry),
          'published' => comment_published(entry),
          'author'    => comment_author(entry)
        }
      end

    hash['entries'] = entries

    hash['pagination'] = [
      {
        'number' => 1,
        'url' => comments_page_path
      }
    ]
    end
  end

  private
    def start_index
      params['start-index'] || 1
    end

    def max_results
      params['max-results'] || 25
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

    def comments_page_path
      "#{node.route_without_site}?parts_params[youtube_video][id]=#{video_id}&parts_params[youtube_video][only_comments]=true"
    end
end
