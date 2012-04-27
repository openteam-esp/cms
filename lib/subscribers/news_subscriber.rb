class NewsSubscriber
  def publish(news)
    send_message('add', news)
  end

  def remove(news)
    send_message('remove', news)
  end

  private
    def send_message(message, news)
      NewsItemPart.where(:news_channel => news['channels']).each do |news_item_part|
        MessageMaker.make_message 'esp.cms.searcher', message, news_item_part.url_with_slug(news['slug'])
      end
    end
end
