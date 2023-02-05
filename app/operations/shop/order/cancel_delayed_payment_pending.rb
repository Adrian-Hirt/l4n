module Operations::Shop::Order
  class CancelDelayedPaymentPending < RailsOps::Operation::Model::Load
    schema3 do
      str! :id, as: :uuid
    end

    load_model_authorization_action :read_public

    policy :on_init do
      fail CanCan::AccessDenied unless model.delayed_payment_pending?
    end

    model ::Order

    lock_mode :exclusive

    def perform
      run_sub Operations::Shop::Order::CleanupSingleOrder, order: model
    end

    def model_id_field
      :uuid
    end
  end
end
