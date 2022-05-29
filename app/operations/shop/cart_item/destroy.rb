module Operations::Shop::CartItem
  class Destroy < RailsOps::Operation::Model::Destroy
    policy :on_init do
      authorize! :use, :shop
    end

    model ::CartItem
  end
end
