module Operations::PaymentGateway
  class GetPaymentInfo < RailsOps::Operation
    schema3 do
      str? :order_id
    end

    without_authorization

    attr_accessor :result

    def perform
      fail InvalidOrder, _('Checkout|No order_id given') if osparams.order_id.blank?

      # Get order
      order = ::Order.find_by(uuid: osparams.order_id)

      # Verify that the order is still active and in the correct state
      fail InvalidOrder, _('Checkout|Order has wrong status') unless order.created? || order.payment_pending?

      fail InvalidOrder, _('Checkout|Order expired') if order.expired?

      fail InvalidOrder, _('Checkout|You did not accepd the terms and conditions') if AppConfig.enable_terms_and_conditions && !order.gtcs_accepted

      # Check that no product_variant has been deleted while loading the payment gateway
      fail InvalidOrder, _('Checkout|An product variant has been deleted') if order.order_items.any? { |order_item| order_item.product_variant.nil? }

      fail InvalidOrder, _('Checkout|No address present') unless order.address_present?

      # Set order as payment pending
      begin
        order.payment_pending!
      rescue ActiveRecord::RecordInvalid
        fail InvalidOrder, _('Checkout|Could not set the order as payment pending')
      end

      @result = {}
      @result[:order_id] = order.uuid

      items = []

      order.order_items.each do |order_item|
        items << {
          product:  order_item.product_name,
          quantity: order_item.quantity,
          price:    order_item.price,
          total:    order_item.price * order_item.quantity
        }
      end

      @result[:items] = items

      # minus 1 minute to have some "padding" between redirect and cleanup
      @result[:valid_until] = order.cleanup_timestamp + ::Order::TIMEOUT_PAYMENT_PENDING - 2.minutes
      total = Money.zero

      order.order_items.each do |order_item|
        total += order_item.total
      end

      promotion_codes = []

      order.promotion_code_mappings.each do |mapping|
        total -= mapping.applied_reduction
        promotion_codes << {
          name:      mapping.promotion_code.promotion.name,
          reduction: mapping.applied_reduction
        }
      end

      @result[:promotion_codes] = promotion_codes

      @result[:total] = total
    end
  end

  class InvalidOrder < StandardError; end
end
