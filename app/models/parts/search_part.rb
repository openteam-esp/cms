# encoding: utf-8

class SearchPart < Part
  validates_presence_of :search_per_page

  default_value_for :search_per_page, 15

  alias_attribute :part_title, :title

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    { 'items' => response_hash }
  end

  private
    def search_engine_url
      Settings['search_engine.url']
    end

    def site_slug
      node.site.slug
    end

    def query
      params['q']
    end

    def page
      params['page'] || 1
    end

    def request_params
      request_params = site_slug
      request_params = "q=#{query}"
      request_params << "&page=#{page}"
      request_params << "&per_page=#{search_per_page}"
    end

    def url_for_request
      p "#{search_engine_url}?#{request_params}"
    end
end
