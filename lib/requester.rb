require 'restclient/components'
require 'rack/cache'

class Requester
  def initialize(url, options = {})
    opts = {
      method: :get,
      url: url,
      timeout: 300,
      verify_ssl: false,
      payload: nil,
      headers: { Accept: nil }
    }
    opts.merge!(options) if options.is_a?(Hash)

    RestClient.enable Rack::CommonLogger
    RestClient.enable Rack::Cache,
      metastore: "file:#{Rails.root.join('tmp/rack-cache/meta')}",
      entitystore: "file:#{Rails.root.join('tmp/rack-cache/body')}",
      verbose: true

    begin
      @response ||= RestClient::Request.execute(opts) do |response, request, result, &block|
        response
      end
    rescue URI::InvalidURIError
      raise(ActionController::RoutingError.new('Not Found'))
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
