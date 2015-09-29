class Spotlight

  attr_accessor :url, :response, :response_code, :response_headers, :response_cookies, :response_body, :response_hash

  def initialize(url)
    @url = url
    @response = RestClient::Request.execute(
      method: :get,
      url: url,
      timeout: 600,
      headers: { :Accept => 'application/json', :timeout => 600 }
    ) do |response, request, result, &block|
      @response_code    = response.code
      @response_headers = response.headers
      @response_cookies = response.cookies
      @response_body    = response.body
      @response_hash    = {
        code: response_code,
        headers: response_headers,
        cookies: response_cookies,
        body: (ActiveSupport::JSON.decode(response_body) rescue :not_json)
      }
    end
  end

end
