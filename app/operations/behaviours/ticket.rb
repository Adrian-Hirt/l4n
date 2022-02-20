module Operations::Behaviours
  class Ticket < RailsOps::Operation
    schema do
      req :product
      req :order_item
    end

    def perform
      osparams.order_item.quantity.times do
        ::Ticket.create!({
                           lan_party:     osparams.product.seat_category.lan_party,
                           seat_category: osparams.product.seat_category,
                           order:         osparams.order_item.order
                         })
      end
    end
  end
end
