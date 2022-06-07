module Operations::Admin::ProductCategory
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      str! :id
      hsh? :grids_admin_product_category_products, additional_properties: true
    end

    model ::ProductCategory

    def grid
      grid_params = osparams.grids_admin_product_category_products || {}
      grid_params[:product_category] = model

      @grid ||= Grids::Admin::ProductCategoryProducts.new(grid_params) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
