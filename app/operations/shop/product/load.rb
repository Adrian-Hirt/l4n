module Operations::Shop::Product
  class Load < RailsOps::Operation::Model::Load
    without_authorization

    policy :on_init do
      authorize! :use, :shop
    end

    model ::Product
  end
end
