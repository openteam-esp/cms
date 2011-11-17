# encoding: utf-8

class NewsItemPart < Part

  def request
    @request ||= Restfulie.at("#{news_url}/public/entries/#{params['slug']}").accepts("application/json").get
  end

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    params ? ActiveSupport::JSON.decode(request.body) : ''
  end

  private
    def news_url
      "#{Settings['news.protocol']}://#{Settings['news.host']}:#{Settings['news.port']}"
    end
end
