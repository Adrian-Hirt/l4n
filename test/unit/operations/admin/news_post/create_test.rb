require 'test_helper'

module Unit
  module Operations
    module Admin
      module NewsPost
        class CreateTest < ApplicationTest
          setup do
            store :user, create_user
            store :context, RailsOps::Context.new(user: fetch(:user))
          end

          def test_only_title
            assert_difference '::NewsPost.count', +1 do
              post = ::Operations::Admin::NewsPost::Create.run!(fetch(:context),
                                                                news_post: {
                                                                  title: 'Testpost'
                                                                }).model.reload

              assert_equal 'Testpost', post.title
              assert_not post.published
              assert_nil post.published_at
              assert_nil post.content
            end
          end

          def test_title_missing
            assert_no_difference '::NewsPost.count' do
              assert_raises ActiveRecord::RecordInvalid do
                ::Operations::Admin::NewsPost::Create.run!(fetch(:context),
                                                           news_post: {
                                                             title: nil
                                                           })
              end
            end
          end

          def test_all_attrs
            assert_difference '::NewsPost.count', +1 do
              post = ::Operations::Admin::NewsPost::Create.run!(fetch(:context),
                                                                news_post: {
                                                                  title:     'Testpost',
                                                                  content:   'Lorem ipsum',
                                                                  published: true
                                                                }).model.reload

              assert_equal 'Testpost', post.title
              assert post.published
              assert_not_nil post.published_at
              assert_equal 'Lorem ipsum', post.content
            end
          end
        end
      end
    end
  end
end
