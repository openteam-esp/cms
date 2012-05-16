class BluePagesSubscriber
  def add_category(category_id, options)
    index 0, category_id
    reindex_parents options
  end

  def remove_category(category_id, options)
    parts(0, category_id).map(&:node).map(&:reindex)
    reindex_parents options
  end

  def add_person(item_id, options)
    send_messages_for_item_pages('add', item_id, options['subdivision']['id'], 0)
    send_messages_for_item_pages('add', item_id, options['subdivision']['parent_ids'].first, 1)
  end

  def remove_person(item_id, options)
    send_messages_for_item_pages('remove', item_id, options['subdivision']['id'], 0)
    send_messages_for_item_pages('remove', item_id, options['subdivision']['parent_ids'].first, 1)
  end

  private
    def parts(level, category_id)
      BluePagesPart.where(:blue_pages_expand => level, :blue_pages_category_id => category_id)
    end

    def send_messages_for_item_pages(message, item_id, category_id, level)
      parts(level, category_id).map(&:item_page).compact.each do |page|
        MessageMaker.make_message 'esp.cms.searcher', message, "#{page.url}-/categories/#{category_id}/items/#{item_id}/"
      end
    end

    def index(level, category_id)
      parts(level, category_id).map(&:index)
    end

    def reindex_parents(options)
      (1..2).each do |level|
        index level, options['parent_ids'][level-1]
      end
    end
end
