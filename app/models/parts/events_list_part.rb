class EventsListPart < NewsListPart
  validates_presence_of :news_event_entry

  protected
    def interval_type
      return news_event_entry unless news_event_entry == 'all'

      events_page < 0 ? 'all_gone' : 'all_coming'
    end

    def order_by
      case interval_type
      when 'gone'
        'event_entry_properties_until desc'
      when 'all_gone'
        'event_entry_properties_since desc'
      when 'coming', 'current', 'all_coming'
        'event_entry_properties_since asc'
      end
    end

    def current_page
      return events_page + 1 if interval_type == 'all_coming'
      return events_page.abs if interval_type == 'all_gone'

      (params['page'] || 1).to_i
    end

    def events_params
      (news_event_entry? ? "&entry_search[interval_type]=#{interval_type}" : '').tap do |string|
        string << "&entry_search[interval_year]=#{interval_year}" if interval_year.present?
        string << "&entry_search[interval_month]=#{interval_month}" if interval_month.present?
      end
    end

    def events_page
      params['events_page'].to_i
    end

    def events_first_page?
      return false if events_page >= 0

      current_page == 1
    end

    def events_last_page?
      return false if events_page < 0

      total_pages <= current_page
    end

    def min_event_datetime
      response_headers['X-Min-Event-Since']
    end

    def max_event_datetime
      response_headers['X-Max-Event-Until']
    end
end
