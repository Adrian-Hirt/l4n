module Operations::Admin::Event
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :event do
        opt :title
        opt :description
      end
    end

    model ::Event
  end
end
