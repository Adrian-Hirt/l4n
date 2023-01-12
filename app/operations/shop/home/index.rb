module Operations::Shop::Home
  class Index < RailsOps::Operation
    schema3 ignore_obsolete_properties: true do
      int? :category_id, cast_str: true
    end

    policy :on_init do
      authorize! :read, :shop
    end

    def products
      @products ||= begin
        relevant_products = ::Product.where(on_sale: true)

        if osparams.category_id.present?
          relevant_products = relevant_products.where(product_category_id: osparams.category_id)
        else
          relevant_products = relevant_products.joins(:product_category).order('product_categories.sort' => :asc)
        end

        relevant_products.order(sort: :asc)
                         .where.associated(:product_variants)
                         .includes(:product_category, :product_variants)
      end
    end

    def available_categories
      @available_categories ||= ::ProductCategory.where(id: ::Product.where(on_sale: true).map(&:id)).order(:name)
    end
  end
end
