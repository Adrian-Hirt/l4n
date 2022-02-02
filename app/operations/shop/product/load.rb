module Operations::Shop::Product
  class Load < RailsOps::Operation::Model::Load
    policy :on_init do
      authorize! :use, :shop
    end

    model ::Product
  end
end
