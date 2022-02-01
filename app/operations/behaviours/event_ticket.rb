module Operations::Behaviours
  class EventTicket < RailsOps::Operation
    schema do
      req :product
      req :order_item
    end

    def perform
      # TODO: implement behaviour to create a ticket here
    end
  end
end
