module Operations::Shop::Order
  class UsePromotionCode < RailsOps::Operation::Model::Update
    model ::Order

    schema3 do
      int! :id, cast_str: true
      hsh! :promotion_code do
        str? :code
      end
    end

    attr_accessor :reduction
    attr_accessor :matching
    attr_accessor :total

    def perform
      @reduction = Money.zero
      @matching = []

      code_str = osparams.promotion_code[:code]

      # Check that we're given a code
      fail InvalidPromotionCode if code_str.blank?

      # Remove whitespace
      code_str = code_str.strip

      # Check that the code exists
      promotion_code = PromotionCode.find_by(code: code_str)

      # Fail if the code does not exist
      fail InvalidPromotionCode if promotion_code.nil?

      # Early return when the code is already applied to the current order
      fail PromoCodeAlreadyApplied if promotion_code.order_id == order.id

      # Check that the code is not used
      fail InvalidPromotionCode if promotion_code.used?

      # Get the promotion the code belongs to
      promotion = promotion_code.promotion

      # Check that the promotion is still active
      fail InvalidPromotionCode unless promotion.active?

      # We need to check that we don't have hit the limit yet for
      # applicable codes. First we simply check that we have more
      # order_items than already applied codes. No matter if we can
      # actually apply the codes or not, but if we already reached
      # the max number of codes we can return early
      order_items = order.order_items
      order_item_count = order_items.sum(&:quantity)

      fail PromoCodeLimitReached if order_item_count <= order.promotion_codes.count

      # Next, we get all the codes of the products, and calculate if there's
      # any mapping of the products and the already applied codes + the new code.
      # If we do not find such a mapping, we can say the code cannot be applied

      # Get the product ids
      product_ids = order_items.map { |order_item| [order_item.product_variant.product_id] * order_item.quantity }.flatten

      # As a shortcut, check if we can apply it at all (i.e. we have any product in the order
      # where we could apply it).
      promotion_code_product_ids = promotion_code.promotion.products.map(&:id)

      # Get the set intersection and check if it's non-empty
      fail PromoCodeCannotBeApplied if (promotion_code_product_ids & product_ids).empty?

      # Get the already applied codes
      applied_codes = order.promotion_codes.map { |code| code.promotion.products.map(&:id) }

      # Add the new code
      codes_to_apply = applied_codes << promotion_code.promotion.products.map(&:id)

      # Calculate all permutations
      codes_to_apply_matrix = codes_to_apply.first.product(*codes_to_apply.drop(1))

      # Check if we have any matching permutations
      matching_permutations = codes_to_apply_matrix.filter_map { |element| element if product_ids.contains_all?(element) }

      # Return if we don't have any permutations
      fail PromoCodeCannotBeApplied if matching_permutations.empty?

      # If it's all good, we add the promotion code to the current order. The total is calculated lated
      promotion_code.order = order
      promotion_code.save!

      order.promotion_codes.reload

      matching_op = run_sub! Operations::Shop::Order::ComputeTotalWithMatching, order: order

      @reduction = matching_op.reduction
      @matching = matching_op.matching
      @total = order.order_items.sum(&:total) - @reduction
    end

    def order
      model
    end
  end

  class InvalidPromotionCode < StandardError; end
  class PromoCodeLimitReached < StandardError; end
  class PromoCodeCannotBeApplied < StandardError; end
  class PromoCodeAlreadyApplied < StandardError; end
end
