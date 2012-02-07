class Youtube::Playlist < Youtube::Resource
  private
    def api_resource_url
      params = 'v=2&alt=json'

      "#{api_url}/playlists/#{id}?#{params}"
    end
end
