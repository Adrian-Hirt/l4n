module Operations::Shop::Order
  class Load < RailsOps::Operation::Model::Load
    model ::Order

    load_model_authorization_action :read_public

    schema3 do
      str! :id, as: :uuid
    end

    policy :on_init do
      fail CanCan::AccessDenied unless model.paid? || model.delayed_payment_pending?
    end

    def model_id_field
      :uuid
    end

    def product_behaviour_hints
      enabled_product_behaviours = model.order_items.collect { |oi| oi.product.enabled_product_behaviour_classes }.flatten.uniq

      enabled_product_behaviours.map { |behaviour| behaviour.order_show_hint(model) }
    end
  end
end
