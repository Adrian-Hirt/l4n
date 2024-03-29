require 'faker'

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
    user_id = ::Operations::User::Create.run!(
      user: {
        username: Faker::Internet.username,
        email:    Faker::Internet.email,
        password: 'Password123'
      }.merge(attrs)
    ).model.id

    User.find(user_id)
  end

  def create_order(user, status)
    ::Order.create!(
      user:              user,
      status:            status,
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

  def create_news_post(title: 'Testpost', content: nil, published: false, user: nil)
    as_user user do
      run_op! ::Operations::Admin::NewsPost::Create, news_post: {
        title:     title,
        content:   content,
        published: published
      }
    end
  end

  def create_tournament(attrs = {})
    ::Operations::Admin::Tournament::Create.run!(
      tournament: {
        name:                       'Testtournament',
        singleplayer:               true,
        max_number_of_participants: 12
      }.merge!(attrs)
    ).model.reload
  end

  def create_tournament_team(name, tournament)
    ::Tournament::Team.create!(
      name:       name,
      tournament: tournament,
      status:     'created',
      password:   'foobar1234'
    )
  end

  def create_tournament_phase(tournament:, phase_attrs: {})
    ::Operations::Admin::Tournament::Phase::CreateForTournament.run!(
      tournament_id:    tournament.id,
      tournament_phase: {
        name:            SecureRandom.alphanumeric,
        size:            6,
        auto_progress:   false,
        tournament_mode: 'single_elimination'
      }.merge!(phase_attrs)
    ).model.reload
  end

  def create_tournament_permission(tournament, user)
    ::UserTournamentPermission.create!(tournament: tournament, user: user)
  end

  def create_lan_party(attrs = {})
    ::Operations::Admin::LanParty::Create.run!(
      lan_party: {
        name:              Random.alphanumeric(10),
        active:            false,
        location:          Random.alphanumeric(16),
        event_start:       (Time.zone.today - 1.day).to_s,
        event_end:         (Time.zone.today + 1.day).to_s,
        sort:              '0',
        sidebar_active:    true,
        timetable_enabled: true,
        seatmap_enabled:   true
      }.merge!(attrs)
    ).model.reload
  end

  def create_user_permission(user, permission, mode)
    UserPermission.create!(
      user:       user,
      permission: permission,
      mode:       mode
    )
  end
end
