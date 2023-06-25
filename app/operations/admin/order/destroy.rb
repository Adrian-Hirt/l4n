module Operations::Admin::Order
  class Destroy < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    lock_mode :exclusive

    policy :on_init do
      # Check that the order can be deleted (i.e. deleteable)
      fail Operations::Exceptions::OpFailed, _('Admin|Order|Wrong status to delete') unless model.deleteable?

      # We can only delete expired orders if the status is created or payment_pending.
      if model.created? || model.payment_pending?
        fail Operations::Exceptions::OpFailed, _('Admin|Order|Not expired yet') unless model.expired?
      end
    end

    model ::Order

    def perform
      if model.created? || model.payment_pending? || model.delayed_payment_pending?
        run_sub Operations::Shop::Order::CleanupSingleOrder, order: model
      elsif model.completed?
        model.destroy!
      else
        fail 'Implausible status!'
      end
    end
  end
end
