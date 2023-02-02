require 'test_helper'

module Unit
  module Permissions
    class TournamentPermissionTest < ApplicationTest
      setup do
        store :user, create_user
        store :admin, create_user(username: 'admin', email: 'admin@example.com')

        # Give the admin user the tournament permission
        fetch(:admin).toggle!(:tournament_admin_permission) # rubocop:disable Rails/SkipsModelValidations

        store :tournament_1, create_tournament(status: Tournament.statuses[:published])
        store :tournament_2, create_tournament(status: Tournament.statuses[:published])
      end

      def test_no_user
        # If the user is not logged in, they should be able
        # to read the frontend of the tournament
        ability = Ability.new(nil)

        ability.can?(:read_public, fetch(:tournament_1))
        ability.can?(:read_public, fetch(:tournament_2))

        # Any other permission should not work
        %i[read update destroy manage].each do |permission|
          assert ability.cannot?(permission, fetch(:tournament_1))
          assert ability.cannot?(permission, fetch(:tournament_2))
        end

        assert ability.cannot? :create, Tournament
      end

      def test_user_without_permission
        # The user should be able to read the tournaments
        # in the frontend
        ability = Ability.new(fetch(:user))

        ability.can?(:read_public, fetch(:tournament_1))
        ability.can?(:read_public, fetch(:tournament_2))

        # Any other permission should not work
        %i[read update destroy manage].each do |permission|
          assert ability.cannot?(permission, fetch(:tournament_1))
          assert ability.cannot?(permission, fetch(:tournament_2))
        end

        assert ability.cannot? :create, Tournament
      end

      def test_admin
        # An admin with the tournament permission should be
        # able to do anything

        # Check that the flag is set to true
        assert fetch(:admin).tournament_admin_permission?

        # Define the ability
        ability = Ability.new(fetch(:admin))

        # All permissions should work
        %i[read_public read update destroy manage].each do |permission|
          assert ability.can?(permission, fetch(:tournament_1))
          assert ability.can?(permission, fetch(:tournament_2))
        end

        assert ability.can? :create, Tournament
      end

      def test_user_with_permissions
        # We give the user permission for the tournament_1,
        # where the user should be able to read and update
        # the tournament, but not destroy or create a tournament
        create_tournament_permission(fetch(:tournament_1), fetch(:user))

        # Define the ability
        ability = Ability.new(fetch(:user).reload)

        # Check the permissions for tournament 1 that should work now
        %i[read_public read update].each do |permission|
          assert ability.can?(permission, fetch(:tournament_1))
        end

        # Check the permissions that still should not work
        %i[destroy manage].each do |permission|
          assert ability.cannot?(permission, fetch(:tournament_1))
        end

        # For tournament 2, everything should be the same as without
        # the newly added permissions
        assert ability.can? :read_public, fetch(:tournament_1)

        %i[read update destroy manage].each do |permission|
          assert ability.cannot?(permission, fetch(:tournament_2))
        end

        # And the user should still not be able to create a tournament
        assert ability.cannot? :create, Tournament

        # Assert the listed tournaments are correct
        assert_equal [fetch(:tournament_1).id], Tournament.accessible_by(ability).map(&:id)
      end
    end
  end
end
