module Youtube
  class Resource
    attr_reader :id, :item_page

    def initialize(attributes)
      @id = attributes[:id]
      @item_page = attributes[:item_page]
    end

    def entries
      request_hashie.feed.entry.map do |e|
        video_id = video_id(e)

        {
          'link' => "#{item_page.route_without_site}?parts_params[youtube_video][id]=#{video_id}",

          'video' => {
            'title'  => video_title(e),
            'thumb'  => video_thumb(video_id)
          },
        }
      end
    end

    def include?(video_id)
      request_hashie.feed.entry.map { |e| video_id(e) }.include?(video_id)
    end

    protected
      def api_url
        'http://gdata.youtube.com/feeds/api'
      end

      def request
        @request ||= Curl::Easy.perform(api_resource_url) do |curl|
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
