module Operations::Shop::CartItem
  class Destroy < RailsOps::Operation::Model::Destroy
    without_authorization

    policy :on_init do
      authorize! :use, :shop
    end

    model ::CartItem
  end
end
