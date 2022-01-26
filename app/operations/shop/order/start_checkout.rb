module Operations::Shop::Order
  class StartCheckout < RailsOps::Operation::Model
    without_authorization

    model ::Order

    def perform
      model.payment_pending!
    end

    def build_model
      @model = Order.find_by(user: context.user, status: 'created')
    end

    def payment_path
      'foo'
    end
  end
end
