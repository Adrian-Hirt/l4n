module Operations::Admin::Tournament
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament
  end
end
