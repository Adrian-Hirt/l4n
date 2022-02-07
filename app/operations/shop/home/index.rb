module Operations::Shop::Home
  class Index < RailsOps::Operation
    without_authorization

    policy :on_init do
      authorize! :use, :shop
    end

    def products
      ::Product.where(on_sale: true)
    end
  end
end
