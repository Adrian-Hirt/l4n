module Operations::Shop::Product
  class Load < RailsOps::Operation::Model::Load
    without_authorization

    model ::Product
  end
end
