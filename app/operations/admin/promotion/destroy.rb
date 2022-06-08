module Operations::Admin::Promotion
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      str! :id
    end

    model ::Promotion
  end
end
