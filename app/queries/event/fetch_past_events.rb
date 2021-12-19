module Queries::Event
  class FetchPastEvents < Inquery::Query
    def call
      # Fetch events that are in the past, i.e. the end_date is
      # smaller than the current date
      rel = Event.all

      rel = rel.joins("
        INNER JOIN (
          SELECT DISTINCT ON (event_id) * FROM event_dates
          WHERE event_id NOT IN (
            SELECT DISTINCT ON (event_id) event_id
            FROM event_dates
            WHERE event_dates.start_date >= '#{Time.zone.today}'
            OR (
              event_dates.start_date <= '#{Time.zone.today}'
              AND event_dates.end_date >= '#{Time.zone.today}'
            )
            ORDER BY event_id, start_date ASC
          )
          ORDER BY event_id, start_date ASC
        ) AS event_dates_grouped
        ON events.id = event_dates_grouped.event_id
      ")

      rel.order('event_dates_grouped.start_date ASC')
    end
  end
end
