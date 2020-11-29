module Operations::Admin::User
  class Load < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::User
  end
end
