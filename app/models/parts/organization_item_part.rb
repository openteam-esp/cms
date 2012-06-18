class OrganizationItemPart < Part
  def to_json
    super.merge!('content' => response_hash)
  end

  private
    def blue_pages_url
      "#{Settings['blue-pages.url']}"
    end

    def url_for_request
      "#{blue_pages_url}/innorganizations/#{resource_id}"
    end

    def urls_for_index
      @urls_for_reindex ||= Requester.new("#{blue_pages_url}/innorganizations", headers_accept).response_hash['organizations'].map { |organization|
        "#{node.url}-/#{organization['id']}"
      }
    end
end
