module Operations::Admin::Page
  class Destroy < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::Page
  end
end
