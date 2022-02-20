module Operations::Behaviours
  class DummyBehaviour < RailsOps::Operation
    schema do
      req :product
      req :order_item
    end

    def perform; end
  end
end
