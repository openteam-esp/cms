# encoding: utf-8

class NewsItemPart < Part

  def request
    @request ||= Restfulie.at("#{news_url}/public/entries/#{params.slug}").accepts("application/json").get
  end

  def request_body
    ActiveSupport::JSON.decode request.resource
  end
end
