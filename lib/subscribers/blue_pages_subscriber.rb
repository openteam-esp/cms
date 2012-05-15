class BluePagesSubscriber
  def add_category(category_id, options)
    index 0, category_id
    reindex_parents options
  end

  def remove_category(id, options)
    BluePagesPart.where(:blue_pages_expand => 0, :blue_pages_category_id => id).map(&:unindex)
    reindex_parents options
  end

  def add_item(id, options)
    index 0, options['subdivision']['id']
    reindex_parents 'parent_ids' => options['subdivision']['parent_ids'] if options['position'] == 1
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
