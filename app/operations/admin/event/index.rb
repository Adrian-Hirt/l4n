module Operations::Admin::Event
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Event
    end

    def events
      Queries::Event::FetchFutureEvents.run
    end
  end
end
