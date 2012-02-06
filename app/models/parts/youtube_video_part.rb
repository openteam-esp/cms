class YoutubeVideoPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    {
      'video' => video_info,
      'embedded_code' => embedded_code,
      'comments' => comments
    }
  end

  def page_title
    title
  end

  delegate :comments, :to => :comments_part

  private
    def video_id
      params['id']
    end

    def api_url
      'http://gdata.youtube.com/feeds/api'
    end

    def api_video_url
      params = 'alt=json&v=2'

      "#{api_url}/videos/#{video_id}?#{params}"
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

    def video_url
      params = 'autoplay=1&hd=1'

      "http://www.youtube.com/v/#{video_id}?#{params}"
    end

    def embedded_code
      params = 'autoplay=1'

      code = <<-END
        <iframe width="560" height="315" src="http://www.youtube.com/embed/#{video_id}?#{params}" frameborder="0" allowfullscreen></iframe>
      END
    end

    def only_comments
      params['only_comments']
    end

    def comments_part
      @comments_part ||= YoutubeCommentsPart.new(:node => node, :params => params)
    end
end
