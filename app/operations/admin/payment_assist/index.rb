module Operations::Admin::PaymentAssist
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_payment_assist_orders, additional_properties: true
    end

    policy :on_init do
      authorize! :use, :payment_assist
    end

    def grid
      @grid ||= Grids::Admin::PaymentAssistOrders.new(osparams.grids_admin_payment_assist_orders) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
