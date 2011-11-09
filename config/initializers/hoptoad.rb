HoptoadNotifier.configure do |config|
  config.api_key = Settings['hoptoad.api_key']
  config.host = Settings['hoptoad.host']
end if defined?(HoptoadNotifier) && Settings['hoptoad']
