module Operations::Event
  class Load < RailsOps::Operation::Model::Load
    schema do
      req :id
    end

    model ::Event
  end
end
