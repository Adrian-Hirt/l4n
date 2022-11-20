require 'test_helper'

module Unit
  module Operations
    module User
      class CreateTest < ApplicationTest
        def test_basic
          # Assert that a user was created
          assert_difference '::User.count', 1 do
            user = ::Operations::User::Create.run!(
              user: {
                username: 'Testuser',
                email:    'testuser@example.com',
                password: 'Password123'
              }
            ).model.reload

            # Assert the user was correctly created
            assert_equal 'Testuser', user.username
            assert_equal 'testuser@example.com', user.email
            assert user.valid_password?('Password123')
            assert user.activation_token.present?
            assert_not user.activated?
          end
        end

        def test_missing_attributes
          # Test where any of the following attributes is missing (blank string):
          # - Username
          # - Email
          # - Password

          assert_no_difference '::User.count' do
            assert_raises ActiveRecord::RecordInvalid do
              ::Operations::User::Create.run!(
                user: {
                  username: '',
                  email:    'testuser@example.com',
                  password: 'Password123'
                }
              )
            end
          end

          assert_no_difference '::User.count' do
            assert_raises ActiveRecord::RecordInvalid do
              ::Operations::User::Create.run!(
                user: {
                  username: 'Testuser',
                  email:    '',
                  password: 'Password123'
                }
              )
            end
          end

          assert_no_difference '::User.count' do
            assert_raises ActiveRecord::RecordInvalid do
              ::Operations::User::Create.run!(
                user: {
                  username: 'Testuser',
                  email:    'testuser@example.com',
                  password: ''
                }
              )
            end
          end
        end

        def test_duplicate_user
          # First, create an user
          assert_difference '::User.count', 1 do
            ::Operations::User::Create.run!(
              user: {
                username: 'Testuser',
                email:    'testuser@example.com',
                password: 'Password123'
              }
            )
          end

          # Now we try to create an user with the same username, but
          # a different emaill
          assert_no_difference '::User.count' do
            assert_raises ActiveRecord::RecordInvalid do
              ::Operations::User::Create.run!(
                user: {
                  username: 'Testuser',
                  email:    'another@example.com',
                  password: 'Password123'
                }
              )
            end
          end

          # Now we try to create an user with the same username, but
          # a different emaill
          assert_no_difference '::User.count' do
            assert_raises ActiveRecord::RecordInvalid do
              ::Operations::User::Create.run!(
                user: {
                  username: 'Another user',
                  email:    'testuser@example.com',
                  password: 'Password123'
                }
              )
            end
          end
        end
      end
    end
  end
end
