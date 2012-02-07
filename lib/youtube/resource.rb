module Youtube
  class Resource
    attr_reader :id, :max_results

    def initialize(attributes)
      @id = attributes[:id]
      @max_results = attributes[:max_results]
    end

    def entries
      request_hashie.feed.entry
    end

    def include?(video_id)
      request_hashie.feed.entry.map { |e| video_id(e) }.include?(video_id)
    end

    protected
      def api_url
        'http://gdata.youtube.com/feeds/api'
      end

      def request_params
        'v=2&alt=json'.tap do |string|
          string << "&max-results=#{max_results}" if max_results
        end
      end

      def request_url
        "#{api_resource_url}?#{request_params}"
      end

      def request
        @request ||= Curl::Easy.perform(request_url) do |curl|
          curl.headers['Accept'] = 'application/json'
        end
      end

      def request_json
        @request_json ||= ActiveSupport::JSON.decode(request.body_str)
      end

      def request_hashie
        @request_hashie ||= Hashie::Mash.new(request_json)
      end

      def video_id(entry)
        entry.send('media$group'.to_sym).send('yt$videoid'.to_sym).send(:$t)
      end

      def video_title(entry)
        entry.title.send(:$t)
      end

      def video_thumb(video_id)
        "http://img.youtube.com/vi/#{video_id}/0.jpg"
      end
  end
end
