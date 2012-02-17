module Youtube
  class Video
    attr_reader :id, :node, :params, :resource_id, :resource_kind

    def initialize(attributes)
      @id = attributes[:id]
      @node = attributes[:node],
      @params = attributes[:params],
      @resource_id = attributes[:resource_id]
      @resource_kind = attributes[:resource_kind]
    end

    def info
      return {} unless resource.include?(id)

      {
        'video' => video_info,
        'embedded_code' => embedded_code
      }
    end

    def response_status
      request.response_code
    end

    private
      def api_url
        'http://gdata.youtube.com/feeds/api'
      end

      def api_video_url
        params = 'alt=json&v=2'

        "#{api_url}/videos/#{id}?#{params}"
      end

      def resource_attributes
        { :id => resource_id }
      end

      def resource
        resource_kind == 'playlist' ? Youtube::Playlist.new(resource_attributes) : Youtube::User.new(resource_attributes)
      end

      def request
        @request ||= Curl::Easy.perform(api_video_url) do |curl|
          curl.headers['Accept'] = 'application/json'
        end
      end

      def request_json
        @request_json ||= ActiveSupport::JSON.decode(request.body_str)
      end

      def request_hashie
        @request_hashie ||= Hashie::Mash.new(request_json)
      end

      def entry
        request_hashie.entry
      end

      def title
        entry.title.send(:$t)
      end

      def description
        entry.send('media$group'.to_sym).send('media$description'.to_sym).send(:$t)
      end

      def views_count
        entry.send('yt$statistics'.to_sym).try(:viewCount)
      end

      def likes_count
        entry.send('yt$rating'.to_sym).try(:numLikes)
      end

      def dislikes_count
        entry.send('yt$rating'.to_sym).try(:numDislikes)
      end

      def video_info
        {
          'title'         => title,
          'description'   => description,
          'views'         => views_count,
          'likes'         => likes_count,
          'dislikes'      => dislikes_count
        }
      end

      def embedded_code
        params = 'autoplay=1'

        code = <<-END
          <iframe width="560" height="315" src="http://www.youtube.com/embed/#{id}?#{params}" frameborder="0" allowfullscreen></iframe>
        END
      end
  end
end
