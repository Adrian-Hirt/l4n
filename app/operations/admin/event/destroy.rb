module Operations::Admin::Event
  class Destroy < RailsOps::Operation::Model::Destroy
    schema do
      req :id
    end

    model ::Event
  end
end
