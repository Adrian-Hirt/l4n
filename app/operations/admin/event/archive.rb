module Operations::Admin::Event
  class Archive < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Event
    end

    def events
      Queries::Event::FetchPastEvents.run
    end
  end
end
