class Youtube::Comments < Youtube::Video
  attr_reader :node, :params, :video_id

  def initialize(attributes)
    @node = attributes[:node]
    @params = attributes[:params]
    @video_id = attributes[:video_id]
  end

  def entries
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
    def start_index
      (params['start-index'] || 1).to_i
    end

    def max_results
      (params['max-results'] || 10).to_i
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

    def profile_url(username)
      "http://www.youtube.com/user/#{username}"
    end

    def author(entry)
      username = entry.author.first.name.send(:$t)

      {
        'username' => username,
        'profile_url' => profile_url(username)
      }
    end

    def page_path(start_index)
      params =  [
        "parts_params[youtube_video][id]=#{video_id}",
        "parts_params[youtube_video][only_comments]=true",
        "parts_params[youtube_video][start-index]=#{start_index}",
        "parts_params[youtube_video][max-results]=#{max_results}"
      ].join('&')

      "#{node.route_without_site}?#{params}"
    end

    def total_pages
      request_hashie.feed.send('openSearch$totalResults'.to_sym).send(:$t).to_i / max_results
    end

    def current_page
      @current_page ||= start_index / max_results
    end

    # TODO: обрабатывать количество страниц
    def pagination
      [].tap do |array|
        (0..10).each do |i|
          start_index = (max_results * i) + 1

          hash = { 'number' => i + 1, 'url' => page_path(start_index) }
          hash.merge!('current' => true) if current_page == i

          array << hash
        end
      end
    end
end
