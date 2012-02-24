class Requester
  def initialize(url)
    @response = Curl::Easy.perform(url) do |curl|
      curl.headers['Accept'] = 'application/json'
    end
  end

  def response
    @response
  end

  def response_headers
    @response_headers ||= Hash[response.header_str.split("\r\n").map { |s| s.split(':').map(&:strip) }]
  end

  def response_status
    @response_status ||= response.response_code
  end

  def response_body
    @response_body ||= response.body_str
  end

  def response_hash
    @response_hash ||= ActiveSupport::JSON.decode(response_body)
  end
end
