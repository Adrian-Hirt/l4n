module Operations::Shop::Home
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, :shop
    end

    def products
      ::Product.where(on_sale: true).includes(:product_category)
    end
  end
end
