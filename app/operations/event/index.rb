module Operations::Event
  class Index < RailsOps::Operation
    schema3 do
      str? :page
    end

    policy :on_init do
      authorize! :read, Event
    end

    def events
      Queries::Event::FetchFutureEvents.run.where(published: true).page(osparams.page)
    end
  end
end
