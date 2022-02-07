module Operations::Admin::Product
  class Destroy < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::Product
  end
end
