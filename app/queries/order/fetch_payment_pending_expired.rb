module Queries::Order
  class FetchPaymentPendingExpired < Inquery::Query
    def call
      ::Order.where(status: Order.statuses[:payment_pending]).where('cleanup_timestamp < ?', Time.zone.now - ::Order::TIMEOUT_PAYMENT_PENDING)
    end
  end
end
