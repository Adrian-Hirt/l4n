module Operations::Admin::NewsPost
  class Destroy < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::NewsPost
  end
end
