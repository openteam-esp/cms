class BluePagesItemPart < Part
  def request
    @request ||= Restfulie.at("#{blue_pages_url}/#{params['link']}").accepts("application/json").get
  end

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    params['link'] ? ActiveSupport::JSON.decode(request.body) : ''
  end

  def blue_pages_url
    "#{Settings['blue_pages.protocol']}://#{Settings['blue_pages.host']}:#{Settings['blue_pages.port']}"
  end
end
