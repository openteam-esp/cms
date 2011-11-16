class NewsPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    ActiveSupport::JSON.decode Restfulie.at("#{news_url}/entries?per_page=#{news_count}").accepts("application/json").get.body
  end

  private
    def news_url
      "#{Settings['news.protocol']}://#{Settings['news.host']}:#{Settings['news.port']}/public/channels/#{news_channel}"
    end
end

