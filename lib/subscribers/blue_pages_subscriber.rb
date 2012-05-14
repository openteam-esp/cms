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
      (1..2).each do |level|
        BluePagesPart.where(:blue_pages_expand => level, :blue_pages_category_id => options['parent_ids'][level-1]).map(&:index)
      end
    end
end
