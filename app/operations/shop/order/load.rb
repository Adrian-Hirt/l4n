module Operations::Shop::Order
  class Load < RailsOps::Operation::Model::Load
    model ::Order

    policy :on_init do
      fail CanCan::AccessDenied unless model.paid? || model.delayed_payment_pending?
    end
  end
end
