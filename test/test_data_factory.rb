module TestDataFactory
  # This module holds helper methods to create test data,
  # e.g. to create an user without much effort for the testing
  # of another model which has an user associated (e.g. a newspost).
  # Usually, these methods should NOT be used to test the behaviour
  # of the data, e.g. don't use the create_user method in user model
  # tests. There, you want to create the users directly using the
  # operations. As such, we have the operations tested in their own tests,
  # and can safely use them in other tests to create data.

  def create_user(attrs = {})
    ::Operations::Admin::User::Create.run!(
      user: {
        username: 'Testuser',
        email:    'testuser@example.com',
        password: 'Password123'
      }.merge(attrs)
    ).model.reload
  end

  def create_order_for_checkout(user)
    ::Order.create!(
      user:              user,
      status:            'created',
      cleanup_timestamp: Time.zone.now
    )
  end

  def create_product_category(name = SecureRandom.alphanumeric, sort: 0)
    ::Operations::Admin::ProductCategory::Create.run!(
      product_category: {
        name: name,
        sort: sort
      }
    ).model.reload
  end

  def create_product(name = SecureRandom.alphanumeric, on_sale: true, inventory: 10, product_category_id: ProductCategory.first.id)
    ::Operations::Admin::Product::Create.run!(
      product: {
        name:                name,
        on_sale:             on_sale,
        inventory:           inventory,
        product_category_id: product_category_id
      }
    ).model.reload
  end

  def create_product_variant(product, name = SecureRandom.alphanumeric, price: Money.new(1000))
    ::ProductVariant.create!(
      name:    name,
      product: product,
      price:   price
    )
  end

  # rubocop:disable Metrics/ParameterLists
  def create_promotion(name = SecureRandom.alphanumeric, active: true, code_type: Promotion.code_types[:fixed_value],
                       reduction: nil, product_ids: [], codes_to_generate: 10, code_prefix: nil)
    ::Operations::Admin::Promotion::Create.run!(
      promotion: {
        name:              name,
        active:            active,
        code_type:         code_type,
        reduction:         reduction.to_s,
        code_prefix:       code_prefix,
        product_ids:       product_ids,
        codes_to_generate: codes_to_generate
      }
    ).model.reload
  end
  # rubocop:enable Metrics/ParameterLists

  # Should only be used in tests where we want to quickly test the behaviour of an order_item.
  # Usually, order items are created from a cart_item, as we need to decrease quantity etc.
  def create_order_item(order, product_variant, quantity: 1)
    ::OrderItem.create!(
      order:           order,
      product_variant: product_variant,
      quantity:        quantity,
      price:           product_variant.price.to_s
    )
  end
end
