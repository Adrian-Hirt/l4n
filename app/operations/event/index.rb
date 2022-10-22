module Operations::Event
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :read, Event
    end

    def events
      Queries::Event::FetchFutureEvents.run.where(published: true)
    end
  end
end
