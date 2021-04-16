module Operations::Event
  class Index < RailsOps::Operation
    # No auth needed
    without_authorization

    def events
      # TODO: Add logic to determine future events, ordered by start_date & start_time
      ::Event.all
    end
  end
end
