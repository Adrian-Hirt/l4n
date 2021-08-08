module Operations::Event
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, Event
    end

    def events
      Queries::Event::FetchFutureEvents.run.where(published: true)
    end
  end
end
