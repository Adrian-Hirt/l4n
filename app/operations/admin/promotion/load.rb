module Operations::Admin::Promotion
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      str! :id
    end

    model ::Promotion
  end
end
