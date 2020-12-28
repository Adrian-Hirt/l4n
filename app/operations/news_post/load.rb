module Operations::NewsPost
  class Load < RailsOps::Operation::Model::Load
    schema do
      req :id
    end

    model ::NewsPost
  end
end
