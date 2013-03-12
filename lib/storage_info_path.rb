require 'open-uri'
require 'base64'
require 'progress_bar'

class StorageInfoPath
  attr_accessor :info_path

  def initialize(with_info_path)
    field_name = with_info_path.class.name.underscore.split("_").first + "_info_path"
    self.info_path = with_info_path.send(field_name).gsub(%r{^/}, '')
  end

  def content
    json_for(:cmd => :get, :target => target)["content"]
  end

  private

  def target
    @target ||= "r1_#{Base64.urlsafe_encode64(info_path).strip.tr('=', '')}"
  end

  def url_for(params)
    "#{Settings['storage.url']}/api/el_finder/v2?#{params.to_param}"
  end

  def json_for(params)
    JSON.parse open(url_for(params)).read
  end

  class Migrator
    attr_accessor :klass
    def initialize(klass)
      self.klass = klass
    end

    def migrate
      objects_with_info_path.each do |object|
        object.update_column field_content_name, StorageInfoPath.new(object).content
        bar.increment!
      end
    end

    def bar
      @bar ||= ProgressBar.new(objects_with_info_path.count)
    end

    def objects_with_info_path
      @objects_with_info_path ||= klass.where("#{field_info_path} IS NOT NULL")
    end

    def field_info_path
      self.klass.name.underscore.split("_").first + "_info_path"
    end

    def field_content_name
      self.klass.name.underscore.split("_").first + "_content"
    end
  end
end
