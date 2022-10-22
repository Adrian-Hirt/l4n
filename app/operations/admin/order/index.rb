module Operations::Admin::Order
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_orders, additional_properties: true
    end

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
