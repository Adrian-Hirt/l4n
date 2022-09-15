module Operations::Shop::Order
  class ProcessFreeOrder < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Order

    policy :on_init do
      # Check that the order is actually free
      fail Operations::Exceptions::OpFailed, _('Order|Your total is more than zero') unless model.total.zero?
    end

    def perform
      run_sub Operations::Shop::Order::ProcessPaid, order: model, gateway_name: 'Free Order'
    end
  end
end
