require 'test_helper'

module Unit
  module Operations
    module Admin
      module NewsPost
        class UpdateTest < ApplicationTest
          setup do
            user = create_user
            create_user_permission(user, :news_admin, :manage)
            user.reload

            store :post_1, create_news_post(title: 'Foobar', content: nil, published: false, user: user).model

            store :user_1, user
            store :user_2, create_user(email: 'another@example.com', username: 'foobar')
          end

          def test_update
            post = fetch(:post_1)

            # Check that the data is set
            assert_equal 'Foobar', post.title
            assert_nil post.content
            assert_equal false, post.published

            as_user fetch(:user_1) do
              run_op ::Operations::Admin::NewsPost::Update, id: fetch(:post_1).id, news_post: {
                title:     'New title',
                content:   'Now with content',
                published: true
              }
            end

            # Reload model
            post.reload

            # Check that the data is updated
            assert_equal 'New title', post.title
            assert_equal 'Now with content', post.content
            assert_equal true, post.published
          end
        end
      end
    end
  end
end
