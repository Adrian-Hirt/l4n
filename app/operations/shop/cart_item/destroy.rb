module Operations::Shop::CartItem
  class Destroy < RailsOps::Operation::Model::Destroy
    without_authorization

    model ::CartItem
  end
end
