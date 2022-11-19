module Operations::Admin::StartpageBlock
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::StartpageBlock
  end
end
