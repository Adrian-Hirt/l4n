module Operations::Shop::Order
  class ComputeTotalWithMatching < RailsOps::Operation
    schema3 do
      obj! :order, classes: [Order], strict: false
    end

    # internal use only
    without_authorization

    delegate :order, to: :osparams

    attr_accessor :reduction
    attr_accessor :matching

    def perform
      # The general idea: For each permutation of codes applied, calculate the final sum
      # and select the best one. For this, we need to sort the codes
      # in decreasing order (free items first, then fixed value), and
      # then "apply" the codes to the order_item with the current highest
      # value (for a given product).
      # That way, we can compute the final price after applying all the codes,
      # and know which permutation to use.
      # We probably should store the permutation on the order, such that we don't
      # have to compute it again later.

      @reduction = Money.zero
      @matching = []

      # Do nothing if we have no codes
      return unless order.promotion_codes.any?

      # First compute the data we need for the promotion codes
      fixed_value_data = []
      free_item_data = []

      order.promotion_codes.each do |promotion_code|
        if promotion_code.promotion.fixed_value?
          fixed_value_data << {
            id:          promotion_code.id,
            product_ids: promotion_code.promotion.products.map(&:id),
            reduction:   promotion_code.promotion.reduction,
            type:        promotion_code.promotion.code_type
          }
        else
          free_item_data << {
            id:          promotion_code.id,
            product_ids: promotion_code.promotion.products.map(&:id),
            type:        promotion_code.promotion.code_type
          }
        end
      end

      # Then sort the array with the fixed reduction in descending order
      fixed_value_data = fixed_value_data.sort_by { |data| data[:reduction] }.reverse

      # Concat all data
      all_codes = free_item_data + fixed_value_data

      # Get the codes we want to apply
      codes_to_apply = all_codes.pluck(:product_ids)

      # Get the product ids
      product_ids = order.order_items.map { |order_item| [order_item.product_variant.product_id] * order_item.quantity }.flatten

      # Calculate all permutations
      codes_to_apply_matrix = codes_to_apply.first.product(*codes_to_apply.drop(1))

      # Calculate the matching permutations
      matching_permutations = codes_to_apply_matrix.map.with_index(0) { |element, _idx| product_ids.contains_all?(element) ? element : nil }.compact

      # Error if we have no matching permutations (this should have been checked before though)
      fail PromoCodeCannotBeApplied if matching_permutations.empty?

      # Prepare the order_item data
      order_item_data = []
      counter = 0

      order.order_items.each do |order_item|
        order_item.quantity.times do
          item = {
            product_id:         order_item.product_variant.product_id,
            product_variant_id: order_item.product_variant_id,
            price:              order_item.price,
            id:                 counter
          }

          order_item_data << item
          counter += 1
        end
      end

      # Finally, calculate the best permutation
      best_reduction = Money.zero
      best_mapping = []

      # Iterate over each permutation
      matching_permutations.each do |permutation|
        current_reduction = Money.zero
        current_data = order_item_data.dup
        current_mapping = []

        # Iterate over each entry of the permutation
        permutation.each_with_index do |product_id, index|
          # Get the data of the current code
          promotion_code_data = all_codes[index]

          current_mapping_item = {
            promotion_code_id: promotion_code_data[:id]
          }

          # Find entry with highest value and "use" that
          highest_match = current_data.find_all { |d| d[:product_id] == product_id }.max_by { |e| e[:price] }

          # Store the product_variant
          current_mapping_item[:product_variant_id] = highest_match[:product_variant_id]

          # Remove the highest match
          current_data.delete(highest_match)

          # Add to counter, either the reduction of the code, or if
          # it's a free item one the price of the matched product
          if promotion_code_data[:type] == 'fixed_value'
            # Get the min of the reduction and the price of the item
            reduction_value = [promotion_code_data[:reduction], highest_match[:price]].min
          else
            # If it's a free item, just directly take the price of the item
            reduction_value = highest_match[:price]
          end

          # Add the reduction to the total
          current_reduction += reduction_value
          current_mapping_item[:reduction] = reduction_value

          current_mapping << current_mapping_item
        end

        # Check if the permutation we calculated is the best
        if current_reduction > best_reduction
          best_reduction = current_reduction
          best_mapping = current_mapping
        end
      end

      @reduction = best_reduction

      best_mapping.each do |mapping_item|
        @matching << {
          promotion_code:  PromotionCode.find(mapping_item[:promotion_code_id]),
          product_variant: ProductVariant.find(mapping_item[:product_variant_id]),
          reduction:       mapping_item[:reduction]
        }
      end
    end

    class PromoCodeCannotBeApplied < StandardError; end
  end
end
