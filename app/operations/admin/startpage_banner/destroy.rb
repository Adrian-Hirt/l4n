module Operations::Admin::StartpageBanner
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::StartpageBanner
  end
end
