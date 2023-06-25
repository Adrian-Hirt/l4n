module Operations::Shop::Order
  class UsePromotionCode < RailsOps::Operation::Model::Load
    model ::Order

    schema3 do
      int! :id, cast_str: true
      hsh! :promotion_code do
        str? :code
      end
    end

    load_model_authorization_action :read_public

    lock_mode :exclusive

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

      if promotion_code.promotion_code_mapping.present?
        # Fail when the code is already applied to the current order
        fail PromoCodeAlreadyApplied if promotion_code.promotion_code_mapping.order_id == order.id

        # Fail when the code is already applied to another order
        fail InvalidPromotionCode if promotion_code.promotion_code_mapping.order_id != order.id

        # Fail when the code is already marked as used (but the order might not be present
        # in the database anymore).
        fail InvalidPromotionCode if promotion_code.used?
      end

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
      fail PromoCodeCannotBeApplied unless promotion_code_product_ids.intersect?(product_ids)

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
      if promotion_code.promotion_code_mapping.present?
        promotion_code.promotion_code_mapping.update(
          order:             order,
          applied_reduction: nil
        )
      else
        promotion_code.build_promotion_code_mapping(
          order:             order,
          applied_reduction: nil
        )
      end

      promotion_code.promotion_code_mapping.save!

      # Reload the promotion codes association
      order.promotion_code_mappings.reload

      # Find the matching for the current order, for convenience and testability we put this in another
      # operation which we call here
      matching_op = run_sub! Operations::Shop::Order::ComputeTotalWithMatching, order: order

      # Set a few instance variables
      @reduction = matching_op.reduction
      @total = order.order_items.sum(&:total) - @reduction

      # Update the mappings
      order.promotion_code_mappings.each do |mapping|
        found_matching = matching_op.matching.find { |matching| matching[:promotion_code] == mapping.promotion_code }

        fail if found_matching.nil?

        mapping.applied_reduction = found_matching[:reduction]
        mapping.order_item = found_matching[:order_item]
        mapping.save!
      end
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
