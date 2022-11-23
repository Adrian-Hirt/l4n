module Operations::Admin::Upload
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :upload do
        obj? :file
      end
    end

    model ::Upload

    def perform
      model.user = context.user
      super
    end
  end
end
