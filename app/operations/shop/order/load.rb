module Operations::Shop::Order
  class Load < RailsOps::Operation::Model::Load
    model ::Order

    schema3 do
      str! :id, as: :uuid
    end

    policy :on_init do
      fail CanCan::AccessDenied unless model.paid? || model.delayed_payment_pending?
    end

    def model_id_field
      :uuid
    end
  end
end
