require 'test_helper'

module Unit
  class UserTest < ApplicationTest
    setup do
      # Create an user
      store :user_1, create_user

      # Create some shop data
      create_product_category
      store :product_1, create_product
      store :variant_1_1, create_product_variant(fetch(:product_1), price: Money.new(1500))
      store :variant_1_2, create_product_variant(fetch(:product_1), price: Money.new(2500))
      store :product_2, create_product
      store :variant_2_1, create_product_variant(fetch(:product_2), price: Money.new(4500))

      # Create some orders for the user
      store :order, create_order(fetch(:user_1), 'completed')
      create_order_item(fetch(:order), fetch(:variant_1_1), quantity: 1)
      create_order_item(fetch(:order), fetch(:variant_1_2), quantity: 2)

      # Create a cart for the user
      ::Cart.create!(user: fetch(:user_1))

      # Create a team and add the user as a member
      tournament = create_tournament
      store :tournament_team, create_tournament_team('Team', tournament)
      teammember = fetch(:tournament_team).users << fetch(:user_1)

      # Create some tickets for the user
      store :lan_party, create_lan_party

      ::Ticket.create!(
        lan_party: fetch(:lan_party),
        seat_category: ::SeatCategory.create!(name: 'Category 1', color: 'yellow', lan_party: fetch(:lan_party)),
        assignee: fetch(:user_1)
      )

      ::Ticket.create!(
        lan_party: fetch(:lan_party),
        seat_category: ::SeatCategory.create!(name: 'Category 2', color: 'green', lan_party: fetch(:lan_party)),
        assignee: fetch(:user_1)
      )

      # Create achievements for the user
      achievement_1 = ::Achievement.create!(title: 'Best achievement')
      achievement_2 = ::Achievement.create!(title: 'Worst achievement')
      fetch(:user_1).user_achievements.create!(achievement: achievement_1, awarded_at: DateTime.now)
      fetch(:user_1).user_achievements.create!(achievement: achievement_2, awarded_at: DateTime.now)

      # Create some tournament permissions for the user
      fetch(:user_1).permitted_tournaments << tournament

      # Create some admin permissions for the user
      fetch(:user_1).user_permissions.create!(
        permission: 'page_admin',
        mode: 'manage'
      )
    end

    def test_setup_correct
      # First, check that the setup was done correctly
      assert_equal 1, fetch(:user_1).orders.count
      assert_equal fetch(:user_1), fetch(:order).user
      assert fetch(:user_1).cart.present?
      assert_equal 2, fetch(:user_1).tickets.count
      assert_equal 2, fetch(:lan_party).tickets.count
      fetch(:lan_party).tickets.each do |ticket|
        assert_equal fetch(:user_1), ticket.assignee
      end
      assert_equal 2, fetch(:user_1).achievements.count

      assert_equal 1, ::LanParty.count
      assert_equal 2, ::Ticket.count
      assert_equal 2, ::Achievement.count
      assert_equal 1, ::Tournament.count
      assert_equal 1, ::Tournament::Team.count
    end

    def test_deleteable_user
      # Now, delete the user, and assert that the following
      # relations of the user are deleted:
      #  * cart
      #  * team_memberships
      #  * user_achievements
      #  * tournament_permissions
      #  * admin_permissions
      # And check that the following are **not** deleted, but
      # don't belong to any user anymore:
      #  * tickets
      #  * uploads
      #  * orders
      assert fetch(:user_1).deleteable?

      assert_difference ['User.count', 'Order.count', 'Cart.count', 'Tournament::TeamMember.count', 'UserTournamentPermission.count', 'UserPermission.count'], -1 do
        assert_difference ['OrderItem.count', 'UserAchievement.count'], -2 do
          assert_no_difference ['LanParty.count', 'Ticket.count', 'Upload.count', 'Achievement.count', 'Tournament.count', 'Tournament::Team.count'] do
            fetch(:user_1).destroy!
          end
        end
      end

      assert_equal 2, fetch(:lan_party).tickets.reload.count
      fetch(:lan_party).tickets.each do |ticket|
        assert_nil ticket.reload.assignee
      end

      Upload.find_each do |upload|
        assert_nil upload.user
      end
    end

    def test_not_deleteable_user
      # Here, an order of the user is not deleteable (as it's still processing),
      # which means the user cannot be deleted
      fetch(:order).processing!

      assert_not fetch(:user_1).deleteable?

      assert_no_difference ['User.count', 'Order.count', 'Cart.count', 'Tournament::TeamMember.count',
                            'UserTournamentPermission.count', 'UserPermission.count', 'OrderItem.count', 'UserAchievement.count',
                            'LanParty.count', 'Ticket.count', 'Upload.count', 'Achievement.count', 'Tournament.count', 'Tournament::Team.count'] do
        assert_raises ActiveRecord::RecordNotDestroyed do
          fetch(:user_1).destroy!
        end
      end

      assert_equal 2, fetch(:lan_party).tickets.reload.count
      fetch(:lan_party).tickets.each do |ticket|
        assert ticket.reload.assignee.present?
      end

      Upload.find_each do |upload|
        assert upload.user.present?
      end
    end
  end
end