module Operations::Api::V1::Event
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    # No auth, applications are authenticated via their API key

    def result
      result = []

      :: Event.where(published: true).each do |event|
        result << {
          title:       event.title,
          description: event.description,
          location:    event.location,
          url:         context.view.event_url(event),
          dates:       event.event_dates.order(start_date: :asc).map { |date| { start: date.start_date.iso8601, end: date.end_date.iso8601 } }
        }
      end

      result
    end
  end
end
