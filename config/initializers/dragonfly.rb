require 'dragonfly'

uploads_app = Dragonfly[:uploads]
uploads_app.configure_with(:rails)
uploads_app.define_macro(ActiveRecord::Base, :upload_accessor)
uploads_app.content_filename = ->(job, request) { request[:file_name] }

if Settings[:s3]
  require 'fog'
  uploads_app.datastore = Dragonfly::DataStorage::S3DataStore.new
  uploads_app.datastore.configure do |datastore|
    Settings[:s3].each do | key, value |
      datastore.send("#{key}=", value)
    end
  end

  class Fog::Storage::AWS::Real
    def initialize_with_openteam(options={})
      initialize_without_openteam(options.merge(:scheme => :http, :port => 80, :host => 's3.openteam.ru'))
    end
    alias_method_chain :initialize, :openteam
  end

  class Fog::Connection
    def request_with_openteam(params, &block)
      request_without_openteam(params.merge(:path => "/news-demo/#{params[:path]}"), &block)
    end
    alias_method_chain :request, :openteam
  end
else
  uploads_app.datastore.configure do |datastore|
    datastore.root_path = "#{Rails.root}/uploads/#{Rails.env}"
    datastore.store_meta = false
  end
end
