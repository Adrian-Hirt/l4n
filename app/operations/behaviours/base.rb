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

    def self.requires_manual_processing?
      # By default, manual processing is not required.
      # Manual processing usually involves steps which
      # need to be taken by actual humans, e.g. packaging
      # an item for shipment.
      #
      # Setting this to true means the order will get the
      # status `processing` after payment instead of `completed`.
      false
    end

    def self.requires_address?
      # By default, product behaviours do not require address
      # data of users. If a product behaviour does need some
      # address data of users, e.g. for shipment, the behaviour
      # needs to specify this.
      false
    end
  end
end
