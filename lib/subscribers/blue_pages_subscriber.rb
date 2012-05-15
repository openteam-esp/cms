class BluePagesSubscriber
  def add_category(category_id, options)
    index 0, category_id
    reindex_parents options
  end

  def remove_category(id, options)
    BluePagesPart.where(:blue_pages_expand => 0, :blue_pages_category_id => id).map(&:unindex)
    reindex_parents options
  end

  def add_person(item_id, options)
    BluePagesPart.where(:blue_pages_expand => 0, :blue_pages_category_id => options['subdivision']['id']).map(&:item_page).compact.each do |page|
      MessageMaker.make_message 'esp.cms.searcher', 'add', "#{page.url}-/categories/#{options['subdivision']['id']}/items/#{item_id}/"
    end
  end

  def remove_person(item_id, options)
    BluePagesPart.where(:blue_pages_expand => 0, :blue_pages_category_id => options['subdivision']['id']).map(&:item_page).compact.each do |page|
      MessageMaker.make_message 'esp.cms.searcher', 'remove', "#{page.url}-/categories/#{options['subdivision']['id']}/items/#{item_id}/"
    end
  end

  private
    def index(level, category_id)
      BluePagesPart.where(:blue_pages_expand => level, :blue_pages_category_id => category_id).map(&:index)
    end

    def reindex_parents(options)
      (1..2).each do |level|
        index level, options['parent_ids'][level-1]
      end
    end
end
