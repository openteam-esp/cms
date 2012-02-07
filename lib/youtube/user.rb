class Youtube::User < Youtube::Resource
  private
    def api_resource_url
      params = 'v=2&alt=json'

      "#{api_url}/users/#{id}/uploads?#{params}"
    end
end
