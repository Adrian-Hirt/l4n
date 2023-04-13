module Operations::Shop::Order
  class ProcessFreeOrder < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    load_model_authorization_action :read_public

    model ::Order

    lock_mode :exclusive

    policy do
      # Check that the order is actually free
      fail Operations::Exceptions::OpFailed, _('Order|Your total is more than zero') unless model.total.zero?

      # Check that all products are still on sale
      model.order_items.each do |order_item|
        next if order_item.product&.on_sale?

        fail Operations::Exceptions::OpFailed, _('ProductVariant|Some products are not on sale anymore')
      end
    end

    def perform
      run_sub Operations::Shop::Order::ProcessPaid, order: model, gateway_name: 'Free Order'
    end
  end
end
