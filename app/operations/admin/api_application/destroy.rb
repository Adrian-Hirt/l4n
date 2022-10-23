module Operations::Admin::ApiApplication
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::ApiApplication
  end
end
