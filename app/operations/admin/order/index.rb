module Operations::Admin::Order
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Order
    end

    def grid
      @grid ||= Grids::Admin::Orders.new(osparams.grids_admin_orders) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
