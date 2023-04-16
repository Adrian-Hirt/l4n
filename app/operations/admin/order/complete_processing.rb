module Operations::Admin::Order
  class CompleteProcessing < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Order

    policy :on_init do
      # Check that we're in the correct state
      fail Operations::Exceptions::OpFailed, _('Admin|Order|Wrong status to complete processing') unless model.processing?
    end

    def perform
      model.completed!
    end
  end
end
