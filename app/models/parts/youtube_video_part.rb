class YoutubeVideoPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    embedded_code
  end

  def page_title
    'Implement me in YoutubeVidoePart#page_title'
  end

  private
    def video_id
      params['id']
    end

    def video_url(video_id)
      params = 'autoplay=1&hd=1'

      "http://www.youtube.com/v/#{video_id}?#{params}"
    end

    def embedded_code
      params = 'autoplay=1'

      code = <<-END
        <iframe width="560" height="315" src="http://www.youtube.com/embed/#{video_id}?#{params}" frameborder="0" allowfullscreen></iframe>
      END
    end
end
