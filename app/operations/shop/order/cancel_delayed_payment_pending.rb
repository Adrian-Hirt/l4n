module Operations::Shop::Order
  class CancelDelayedPaymentPending < RailsOps::Operation::Model::Load
    policy :on_init do
      fail CanCan::AccessDenied unless model.delayed_payment_pending?
    end

    model ::Order

    def perform
      run_sub Operations::Shop::Order::CleanupSingleOrder, order: model
    end
  end
end
