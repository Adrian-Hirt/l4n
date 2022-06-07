module Operations::Admin::ProductCategory
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, ProductCategory
    end

    def grid
      @grid ||= Grids::Admin::ProductCategories.new(osparams.grids_admin_product_categories) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
