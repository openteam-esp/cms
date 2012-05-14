class BluePagesSubscriber
  def add_category(category_id, options)
    BluePagesPart.where(:blue_pages_expand => 0, :blue_pages_category_id => category_id).map(&:index)
    reindex_parents options
  end

  def remove_category(id, options)
    BluePagesPart.where(:blue_pages_expand => 0, :blue_pages_category_id => id).map(&:unindex)
    reindex_parents options
  end

  private
    def reindex_parents(options)
      level = 0
      options['parent_ids'].each do |category_id|
        level += 1
        BluePagesPart.where(:blue_pages_expand => level, :blue_pages_category_id => category_id).map(&:index)
      end
    end
end
