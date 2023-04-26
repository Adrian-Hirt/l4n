require 'test_helper'

module Unit
  module Operations
    module Shop
      module Order
        class ComputeTotalWithMatchingTest < ApplicationTest
          setup do
            store :user, create_user
            store :context, RailsOps::Context.new(user: fetch(:user))

            create_product_category

            store :product_1, create_product
            store :variant_1_1, create_product_variant(fetch(:product_1), price: Money.new(1500))
            store :variant_1_2, create_product_variant(fetch(:product_1), price: Money.new(2500))

            store :product_2, create_product
            store :variant_2_1, create_product_variant(fetch(:product_2), price: Money.new(4500))

            store :order, create_order_for_checkout(fetch(:user))
            store :order_item_1, create_order_item(fetch(:order), fetch(:variant_1_1), quantity: 1)
            store :order_item_2, create_order_item(fetch(:order), fetch(:variant_1_2), quantity: 2)

            # Reload order, just to be safe
            fetch(:order).reload

            store :promotion_1, create_promotion('Fixed', reduction: Money.new(1000), product_ids: [fetch(:product_1).id, fetch(:product_2).id])
            store :promotion_2, create_promotion('Free Item 1 only', code_type: Promotion.code_types[:free_item], product_ids: [fetch(:product_1).id])
          end

          def test_no_codes
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            assert_equal [], result.matching
            assert_equal Money.zero, result.reduction
          end

          def test_single_code
            code_1_1 = fetch(:promotion_1).promotion_codes.first
            code_2_1 = fetch(:promotion_2).promotion_codes.first

            # Apply a code which reduces the total by 10.-
            apply_code(code_1_1)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. The code is applied to the second order item, as we always pick the result
            # with the highest value
            assert_matching [{
              promotion_code_id: code_1_1.id,
              order_item_id:     fetch(:order_item_2).id,
              reduction:         Money.new(1000)
            }], result.matching

            # We have a reduction of 10.-
            assert_equal Money.new(1000), result.reduction

            # Remove the code and apply another one
            remove_code(code_1_1)
            apply_code(code_2_1)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. The code is applied to the second order item, as we always pick the result
            # with the highest value
            assert_matching [{
              promotion_code_id: code_2_1.id,
              order_item_id:     fetch(:order_item_2).id,
              reduction:         Money.new(2500)
            }], result.matching

            # We have a reduction of 25.-
            assert_equal Money.new(2500), result.reduction
          end

          def test_two_codes
            code_1_1 = fetch(:promotion_1).promotion_codes.first
            code_1_2 = fetch(:promotion_1).promotion_codes.second
            code_2_1 = fetch(:promotion_2).promotion_codes.first
            code_2_2 = fetch(:promotion_2).promotion_codes.second

            # Apply 2 codes from the first promo
            apply_code(code_1_1)
            apply_code(code_1_2)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. The code is applied to the second variant, as we always pick the result
            # with the highest value
            assert_matching [
              {
                promotion_code_id: code_1_1.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(1000)
              },
              {
                promotion_code_id: code_1_2.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(1000)
              }
            ], result.matching

            # We have a reduction of 20.-
            assert_equal Money.new(2000), result.reduction

            # Remove codes and apply 2 codes from second promo
            remove_code(code_1_1)
            remove_code(code_1_2)
            apply_code(code_2_1)
            apply_code(code_2_2)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. The code is applied to the second variant, as we always pick the result
            # with the highest value
            assert_matching [
              {
                promotion_code_id: code_2_1.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              },
              {
                promotion_code_id: code_2_2.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              }
            ], result.matching

            # We have a reduction of 50.-
            assert_equal Money.new(5000), result.reduction

            # Remove codes, apply one from promo 1, and one from promo 2
            remove_code(code_2_1)
            remove_code(code_2_2)
            apply_code(code_1_1)
            apply_code(code_2_1)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. The code is applied to the second variant, as we always pick the result
            # with the highest value
            assert_matching [
              {
                promotion_code_id: code_1_1.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(1000)
              },
              {
                promotion_code_id: code_2_1.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              }
            ], result.matching

            # We have a reduction of 35.-
            assert_equal Money.new(3500), result.reduction
          end

          def test_three_codes
            code_1_1 = fetch(:promotion_1).promotion_codes.first
            code_1_2 = fetch(:promotion_1).promotion_codes.second
            code_1_3 = fetch(:promotion_1).promotion_codes.third
            code_2_1 = fetch(:promotion_2).promotion_codes.first
            code_2_2 = fetch(:promotion_2).promotion_codes.second
            code_2_3 = fetch(:promotion_2).promotion_codes.third

            # Apply 3 codes from the first promo
            apply_code(code_1_1)
            apply_code(code_1_2)
            apply_code(code_1_3)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. It's "inverted" (i.e. code_1_1 has the lowest value product) because
            # we sort by decreasing value, which inverts the order of the items with the same value
            assert_matching [
              {
                promotion_code_id: code_1_1.id,
                order_item_id:     fetch(:order_item_1).id,
                reduction:         Money.new(1000)
              },
              {
                promotion_code_id: code_1_2.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(1000)
              },
              {
                promotion_code_id: code_1_3.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(1000)
              }
            ], result.matching

            # We have a reduction of 30.-
            assert_equal Money.new(3000), result.reduction

            # Remove codes and apply 3 codes from second promo
            remove_code(code_1_1)
            remove_code(code_1_2)
            remove_code(code_1_3)
            apply_code(code_2_1)
            apply_code(code_2_2)
            apply_code(code_2_3)

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result. The code is applied to the second variant, as we always pick the result
            # with the highest value
            assert_matching [
              {
                promotion_code_id: code_2_1.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              },
              {
                promotion_code_id: code_2_2.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              },
              {
                promotion_code_id: code_2_3.id,
                order_item_id:     fetch(:order_item_1).id,
                reduction:         Money.new(1500)
              }
            ], result.matching

            # We have a reduction of 65.-
            assert_equal Money.new(6500), result.reduction

            # Remove codes and apply mixed codes
            remove_code(code_2_1)
            remove_code(code_2_2)
            remove_code(code_2_3)

            apply_code(code_2_1) # Free item, should go to variant_1_2
            apply_code(code_1_1) # Fixed value, should go to variant_1_1
            apply_code(code_2_2) # Free item, should go to variant_1_2

            # Run operation
            result = ::Operations::Shop::Order::ComputeTotalWithMatching.run!(order: fetch(:order))

            # Check result
            assert_matching [
              {
                promotion_code_id: code_2_1.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              },
              {
                promotion_code_id: code_2_2.id,
                order_item_id:     fetch(:order_item_2).id,
                reduction:         Money.new(2500)
              },
              {
                promotion_code_id: code_1_1.id,
                order_item_id:     fetch(:order_item_1).id,
                reduction:         Money.new(1000)
              }
            ], result.matching

            # We have a reduction of 60.-
            assert_equal Money.new(6000), result.reduction
          end

          private

          def apply_code(code)
            code.build_promotion_code_mapping(
              order: fetch(:order)
            )
            code.promotion_code_mapping.save!

            fetch(:order).promotion_codes.reload
          end

          def remove_code(code)
            code.promotion_code_mapping.destroy!

            fetch(:order).promotion_codes.reload
          end

          # Expected is of the form [{ promotion_code_id: <id>, order_item_id: <id>, reduction: <Money> }, ...]
          def assert_matching(expected, result)
            result_array = []

            result.each do |result_element|
              result_array << {
                promotion_code_id: result_element[:promotion_code].id,
                order_item_id:     result_element[:order_item].id,
                reduction:         result_element[:reduction]
              }
            end

            assert_equal (expected.sort_by { |data| data[:promotion_code_id] }), (result_array.sort_by { |data| data[:promotion_code_id] })
          end
        end
      end
    end
  end
end
