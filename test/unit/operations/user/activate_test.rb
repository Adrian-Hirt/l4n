require 'test_helper'

module Unit
  module Operations
    module User
      class ActivateTest < ApplicationTest
        setup do
          store :user, create_user
        end

        def test_basic
          # Assert that the user is not activated, and has
          # an activation token
          user = fetch(:user)

          assert user.activation_token.present?
          assert_not user.activated?

          # Now we activate the user
          ::Operations::User::Activate.run!(
            email:            user.email,
            activation_token: user.activation_token
          )

          # Reload changes
          user.reload

          # Check that the user has been activated,
          # and the activation token removed
          assert user.activated?
          assert_nil user.activation_token
        end
      end
    end
  end
end
