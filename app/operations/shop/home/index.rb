module Operations::Shop::Home
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :read, :shop
    end

    def products
      ::Product.where(on_sale: true)
               .joins(:product_category)
               .order('product_categories.sort' => :asc)
               .order(sort: :asc)
               .includes(:product_category, :product_variants)
    end
  end
end
