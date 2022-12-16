module Operations::Api::V1::Event
  class Load < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
    end

    # No auth, applications are authenticated via their API key

    def result
      # Lookup event
      event = ::Event.find(osparams.id)

      # We want the event to be published
      fail ActiveRecord::NotFound unless event.published?

      {
        title:       event.title,
        description: event.description,
        url:         context.view.event_url(event),
        dates:       event.event_dates.order(start_date: :asc).map { |date| { start: date.start_date.iso8601, end: date.end_date.iso8601, location: date.location.presence } }
      }
    end
  end
end
