module Operations::NewsPost
  class Load < RailsOps::Operation::Model::Load
    schema do
      req :id
    end

    # No auth needed
    without_authorization

    model ::NewsPost
  end
end
