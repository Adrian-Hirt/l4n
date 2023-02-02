module Operations::Shop::Product
  class Load < RailsOps::Operation::Model::Load
    schema3 ignore_obsolete_properties: true do
      int! :id, cast_str: true
    end

    load_model_authorization_action :read_public

    attr_reader :requested_quantity

    model ::Product

    def perform
      return unless context.user

      @requested_quantity = 0

      return if context.user.cart.nil?

      context.user.cart.cart_items.each do |cart_item|
        @requested_quantity += cart_item.quantity if cart_item.product == model
      end
    end
  end
end
