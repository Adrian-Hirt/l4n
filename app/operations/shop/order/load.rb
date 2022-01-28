module Operations::Shop::Order
  class Load < RailsOps::Operation::Model::Load
    model ::Order
  end
end
