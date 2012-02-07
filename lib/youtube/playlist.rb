class Youtube::Playlist < Youtube::Resource
  private
    def api_resource_url
      "#{api_url}/playlists/#{id}"
    end
end
