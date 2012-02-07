class Youtube::Comments < Youtube::Video
  attr_reader :node, :params, :video_id

  def initialize(attributes)
    @node = attributes[:node]
    @params = attributes[:params]
    @video_id = attributes[:video_id]
  end

  def entries
    {}.tap do |hash|
      entries = feed_entry.map do |entry|
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

    def feed
      request_hashie.feed
    end

    def feed_entry
      feed.entry || []
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
      (feed.send('openSearch$totalResults'.to_sym).send(:$t).to_f / max_results).ceil
    end

    def current_page
      [(start_index.to_f / max_results), 1].max.ceil
    end

    def page(label, start_index)
      { 'label' => label, 'url' => page_path(start_index) }
    end

    def pagination
      return [] if total_pages.zero?

      start = current_page
      finish = [current_page + 6, total_pages].min

      [].tap do |array|
        #array << page('<<', max_results * (start - 1) + 1) if start > 1

        (start..finish).each do |i|
          s = (max_results * (i - 1)) + 1

          hash = page(i, s)
          hash.merge!('current' => true) if current_page == i

          array << hash
        end

        #array << page('>>', max_results * start + 1) if start < total_pages
      end
    end
end
