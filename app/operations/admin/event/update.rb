module Operations::Admin::Event
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :event do
        opt :title
        opt :description
      end
    end

    model ::Event
  end
end
