# encoding: utf-8

class AppealPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    res = '<div class="remote_wrapper">'
    res << request.body.force_encoding('utf-8')
    res << '</div>'
    res
  end

  def request
    @request ||= Restfulie.at("#{appeals_url}/new").accepts("text/vnd_html").get
  end

  private
    def appeals_url
      "#{Settings['appeals.protocol']}://#{Settings['appeals.host']}:#{Settings['appeals.port']}/public/appeals"
    end
end
