module Operations::Shop::Product
  class Load < RailsOps::Operation::Model::Load
    without_authorization

    policy :on_init do
      authorize! :use, :shop
    end

    attr_reader :requested_quantity

    model ::Product

    def perform
      @requested_quantity = 0

      context.user.cart.cart_items.each do |cart_item|
        @requested_quantity += cart_item.quantity if cart_item.product == model
      end
    end
  end
end
