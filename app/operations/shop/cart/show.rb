module Operations::Shop::Cart
  class Show < RailsOps::Operation::Model
    without_authorization
    attr_reader :reduced_cart_items, :removed_cart_items

    model ::Cart

    def build_model
      @model = Cart.find_or_create_by(user: context.user)
    end

    def perform
      @reduced_cart_items = []
      @removed_cart_items = []

      # Sanitize cart_items
      model.cart_items.each do |cart_item|
        if cart_item.product_variant.availability.zero?
          @removed_cart_items << "#{cart_item.product_variant.product.name} - #{cart_item.product_variant.name}"
          run_sub Operations::Shop::CartItem::Destroy, id: cart_item.id
        elsif cart_item.quantity > cart_item.product_variant.availability
          cart_item.quantity = cart_item.product_variant.availability
          @reduced_cart_items << "#{cart_item.product_variant.product.name} - #{cart_item.product_variant.name}"
          cart_item.save!
        end
      end

      model.cart_items.reload
    end
  end
end
