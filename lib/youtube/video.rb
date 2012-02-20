module Youtube
  class Video
    attr_reader :id, :node, :params, :resource_id, :resource_kind, :height, :width

    delegate :video_id,
             :video_description,
             :video_title,
             :video_uploaded,
             :video_thumb_small,
             :video_thumb_normal, :to => :resource

    def initialize(attributes)
      @id = attributes[:id]
      @node = attributes[:node],
      @params = attributes[:params],
      @resource_id = attributes[:resource_id]
      @resource_kind = attributes[:resource_kind]
      @height = attributes[:height]
      @width = attributes[:width]
    end

    def author
      entry.send(:author).first.send(:name).send(:$t)
    end

    def description
      entry.send('media$group'.to_sym).send('media$description'.to_sym).send(:$t)
    end

    def dislikes_count
      entry.send('yt$rating'.to_sym).try(:numDislikes)
    end

    def embedded_code
      params = 'autoplay=1&wmode=transparent'

      code = <<-END
          <iframe width="#{width}" height="#{height}" src="http://www.youtube.com/embed/#{id}?#{params}" frameborder="0" allowfullscreen></iframe>
      END
    end

    def info
      return {} unless resource.include?(id)

      {
        'video' => video_info,
        'embedded_code' => embedded_code
      }
    end

    def likes_count
      entry.send('yt$rating'.to_sym).try(:numLikes)
    end

    def related_video_entries
      RelatedVideos.new(self).entries
    end

    def response_status
      request.response_code
    end

    def title
      entry.title.send(:$t)
    end

    def views_count
      entry.send('yt$statistics'.to_sym).try(:viewCount)
    end

    private
      def api_url
        'http://gdata.youtube.com/feeds/api'
      end

      def params
        'alt=json&v=2'
      end

      def api_video_url
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

      def video_info
        {
          'title'         => title,
          'description'   => description,
          'views'         => views_count,
          'likes'         => likes_count,
          'dislikes'      => dislikes_count
        }
      end
  end
end
