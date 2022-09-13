module Operations::Admin::Tournament::Team
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    def validation_errors
      super + [ActiveRecord::RecordNotDestroyed]
    end

    model ::Tournament::Team
  end
end
