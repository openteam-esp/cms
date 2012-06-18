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
end
