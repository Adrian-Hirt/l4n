module Operations::Event
  class Index < RailsOps::Operation
    # No auth needed
    without_authorization

    def events
      Queries::Event::FetchFutureEvents.run.where(published: true)
    end
  end
end
