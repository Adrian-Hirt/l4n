module Operations::Admin::Event
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
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
