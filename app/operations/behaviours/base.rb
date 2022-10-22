module Operations::Behaviours
  class Base < RailsOps::Operation
    # Abstract base class for all ticket behaviours. All behaviours
    # should subclass this class and override the needed methods,
    # even if they don't do anything (e.g. define an empty
    # `run_validations` method if there are no validations).

    schema3 do
      obj! :product
      obj! :order_item
    end

    def perform
      fail NotImplementedError
    end

    def self.run_validations(product)
      fail NotImplementedError
    end

    def self.run_before_checkout(cart_item)
      # By default, this does nothing, but can be
      # overwritten
    end

    def self.run_on_cleanup(order_item)
      # By default, this does nothing, but can be
      # overwritten
    end
  end
end
