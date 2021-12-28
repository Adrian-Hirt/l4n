module Operations::Admin::Pages
  class Destroy < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::Page
  end
end
