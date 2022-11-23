module Operations::Admin::Upload
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      str! :id
    end

    model ::Upload

    def perform
      ActiveRecord::Base.transaction do
        model.file.purge
        model.destroy!
      end
    end
  end
end
