module Operations::Admin::Product
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Product
    end

    def grid
      @grid ||= Grids::Admin::Products.new(osparams.grids_admin_products) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
