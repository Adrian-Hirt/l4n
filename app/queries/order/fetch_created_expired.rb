module Queries::Order
  class FetchCreatedExpired < Inquery::Query
    def call
      ::Order.where(status: Order.statuses[:created]).where(cleanup_timestamp: ...(Time.zone.now - ::Order::TIMEOUT))
    end
  end
end
