module Operations::Shop::CartItem
  class DecreaseQuantity < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :use, :shop
    end

    load_model_authorization_action nil

    model ::CartItem

    def perform
      model.quantity -= 1
      if model.quantity.zero?
        run_sub Operations::Shop::CartItem::Destroy, id: model.id
      else
        model.save!
      end
    end
  end
end
