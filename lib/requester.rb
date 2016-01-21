require 'restclient/components'
require 'rack/cache'

class Requester
  def initialize(url, headers_accept = nil)
    RestClient.enable Rack::CommonLogger
    RestClient.enable Rack::Cache,
      :metastore => "file:#{Rails.root.join('tmp/rack-cache/meta')}",
      :entitystore => "file:#{Rails.root.join('tmp/rack-cache/body')}",
      :verbose => true

    @response ||= RestClient::Request.execute(
      :method => :get,
      :url => url,
      :timeout => nil,
      :headers => {
        :Accept => headers_accept
      }
    ) do |response, request, result, &block|
      response
    end
  end

  def response
    @response
  end

  def stringify_headers(headers)
    headers.map do |k, v|
      {
        k.to_s.split('_').map do |s|
          s.capitalize.gsub('Etag', 'ETag').gsub('Ua', 'UA')
        end.join('-') => v
      }
    end.reduce Hash.new, :merge
  end

  def response_headers
    @response_headers ||= stringify_headers response.headers
  end

  def response_status
    @response_status ||= response.code
  end

  def response_body
    @response_body ||= response.body.force_encoding('UTF-8')
  end

  def response_hash
    @response_hash ||= JSON.load(response_body) rescue {}
  end
end
