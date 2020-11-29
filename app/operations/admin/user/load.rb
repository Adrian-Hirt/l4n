module Operations::Admin::User
  class Load < RailsOps::Operation::Model::Load
    schema do
      req :id
    end

    model ::User
  end
end
