module Operations::Shop::Home
  class Index < RailsOps::Operation
    without_authorization

    def products
      ::Product.where(on_sale: true)
    end
  end
end
