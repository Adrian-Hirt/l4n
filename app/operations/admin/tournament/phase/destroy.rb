module Operations::Admin::Tournament::Phase
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    def validation_errors
      super + [ActiveRecord::RecordNotDestroyed]
    end

    model ::Tournament::Phase
  end
end
