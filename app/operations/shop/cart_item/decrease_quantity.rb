module Operations::Shop::CartItem
  class DecreaseQuantity < RailsOps::Operation::Model::Load
    without_authorization

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
