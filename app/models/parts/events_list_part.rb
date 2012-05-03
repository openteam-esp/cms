class EventsListPart < NewsListPart
  validates_presence_of :news_event_entry

  protected
    def search_params
      super << "&events_type=#{news_event_entry}"
    end
end
