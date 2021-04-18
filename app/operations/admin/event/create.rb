module Operations::Admin::Event
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :event do
        opt :title
        opt :location
        opt :published
        opt :description
        opt :event_dates_attributes
      end
    end

    model ::Event
  end
end
