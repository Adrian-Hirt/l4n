module Operations::Admin::User
  class Destroy < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::User
  end
end
