module Queries::Order
  class FetchDelayedPaymentPendingExpired < Inquery::Query
    # This query fetches all orders which are in the state of "delayed payment pending",
    # which usually is set when the payment has to be made manually, e.g. paying in
    # person or via bank transfer. That's why this status has an increased timeout compared
    # to the normal ones.
    def call
      ::Order.where(status: Order.statuses[:delayed_payment_pending])
             .where(cleanup_timestamp: ...(Time.zone.now - ::Order::TIMEOUT_DELAYED_PAYMENT_PENDING))
    end
  end
end
