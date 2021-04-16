module Operations::Event
  class Load < RailsOps::Operation::Model::Load
    schema do
      req :id
    end

    # No auth needed
    without_authorization

    model ::Event
  end
end
