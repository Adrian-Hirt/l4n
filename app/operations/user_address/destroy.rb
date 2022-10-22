module Operations::UserAddress
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::UserAddress
  end
end
