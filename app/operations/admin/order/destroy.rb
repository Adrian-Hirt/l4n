module Operations::Admin::Order
  class Destroy < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      # Check that we're in the correct state
      fail Operations::Exceptions::OpFailed, _('Admin|Order|Wrong status to delete') unless model.created? || model.payment_pending?

      # We can only delete expired orders
      fail Operations::Exceptions::OpFailed, _('Admin|Order|Not expired yet') unless model.expired?
    end

    model ::Order

    def perform
      run_sub Operations::Shop::Order::CleanupSingleOrder, order: model
    end
  end
end
