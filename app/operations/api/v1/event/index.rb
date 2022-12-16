module Operations::Api::V1::Event
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    # No auth, applications are authenticated via their API key

    def result
      result = []

      Queries::Event::FetchFutureEvents.run.where(published: true).each do |event|
        result << {
          title:       event.title,
          description: event.description,
          url:         context.view.event_url(event),
          dates:       event.event_dates.order(start_date: :asc).map { |date| { start: date.start_date.iso8601, end: date.end_date.iso8601, location: date.location.presence } }
        }
      end

      result
    end
  end
end
