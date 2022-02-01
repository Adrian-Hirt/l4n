module Operations::Shop::Cart
  class Show < RailsOps::Operation::Model
    without_authorization
    attr_reader :unavailable_products, :products_with_less_availability, :availability_error, :quantity_by_product

    model ::Cart

    def build_model
      @model = Cart.includes(cart_items: { product_variant: :product }).find_or_create_by(user: context.user)
    end

    def perform
      # Delete other orders for user that have status `created`
      run_sub! Operations::Shop::Order::CleanupUntouched

      @quantity_by_product = {}
      @unavailable_products = []
      @products_with_less_availability = {}
      @availability_error = false

      # Sanitize cart_items
      model.cart_items.each do |cart_item|
        @quantity_by_product[cart_item.product] ||= 0
        @quantity_by_product[cart_item.product] += cart_item.quantity
      end

      @quantity_by_product.each do |product, quantity_requested|
        if product.availability.zero?
          @unavailable_products << product.id
          @availability_error = true
        elsif quantity_requested > product.availability
          @products_with_less_availability[product.id] = { availability: product.availability }
          @availability_error = true
        end
      end
    end
  end
end
