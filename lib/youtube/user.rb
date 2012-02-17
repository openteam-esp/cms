class Youtube::User < Youtube::Resource
  private
    def api_resource_url
      "#{api_url}/users/#{id}/uploads"
    end
end
