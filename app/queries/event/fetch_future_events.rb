module Queries::Event
  class FetchFutureEvents < Inquery::Query
    def call
      # Fetch events where the start date is in the future, or
      # events where the start date is in the past (i.e. the event
      # already started), but the end is in the future (i.e. the event
      # is still going on)
      rel = Event.all

      rel = rel.joins("
        INNER JOIN (
          SELECT DISTINCT ON (event_id) *
          FROM event_dates
          WHERE event_dates.start_date >= '#{Time.zone.today}'
          OR (
            event_dates.start_date <= '#{Time.zone.today}'
            AND event_dates.end_date >= '#{Time.zone.today}'
          )
          ORDER BY event_id, start_date ASC, start_time ASC
        ) AS event_dates_grouped
        ON events.id = event_dates_grouped.event_id
      ")

      rel.order('event_dates_grouped.start_date ASC, event_dates_grouped.start_time ASC')
    end
  end
end
