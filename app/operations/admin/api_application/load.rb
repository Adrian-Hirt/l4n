module Operations::Admin::ApiApplication
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::ApiApplication
  end
end
