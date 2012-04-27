class NewsSubscriber
  def publish(news)
    send_message('add', news)
  end

  def remove(news)
    send_message('remove', news)
  end

  private
    def send_message(message, news)
      news = JSON.parse(news)
      NewsItemPart.where(:news_channel => news['channel_ids'].map(&:to_s)).select(&:indexable?).each do |news_item_part|
        MessageMaker.make_message 'esp.cms.searcher', message, news_item_part.url_with_slug(news['slug'])
      end
    end
end
