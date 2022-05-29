module Operations::Shop::Cart
  class Show < RailsOps::Operation::Model
    policy :on_init do
      authorize! :use, :shop
    end

    attr_reader :unavailable_products
    attr_reader :products_with_less_availability
    attr_reader :availability_error
    attr_reader :quantity_requested_by_product
    attr_reader :availability_by_product

    model ::Cart

    def build_model
      @model = Cart.includes(cart_items: { product_variant: :product }).find_or_create_by(user: context.user)
    end

    def perform
      # Delete other orders for user that have status `created`
      run_sub! Operations::Shop::Order::CleanupUntouched

      @quantity_requested_by_product = {}
      @availability_by_product = {}
      @unavailable_products = []
      @products_with_less_availability = {}
      @availability_error = false

      # Sanitize cart_items
      model.cart_items.each do |cart_item|
        @quantity_requested_by_product[cart_item.product] ||= 0
        @quantity_requested_by_product[cart_item.product] += cart_item.quantity
      end

      @quantity_requested_by_product.each do |product, quantity_requested|
        @availability_by_product[product] = product.availability
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
