class NewsSubscriber
  def publish(news)
    NewsItemPart.where(:news_channel => news['channels']).each do |news_item_part|
      MessageMaker.make_message 'esp.cms.searcher', 'add', news_item_part.url_with_slug(news['slug'])
    end
  end
end
