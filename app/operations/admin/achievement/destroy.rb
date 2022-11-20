module Operations::Admin::Achievement
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::Achievement
  end
end
