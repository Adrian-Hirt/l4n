require 'test_helper'

module Unit
  module Operations
    module Admin
      module Event
        class UpdateTest < ApplicationTest
          setup do
            store :event, ::Operations::Admin::Event::Create.run!(event: {
                                                                    title:                  'Testpost',
                                                                    published:              true,
                                                                    description:            'A fun event',
                                                                    event_dates_attributes: [{
                                                                      start_date: '2022-02-20T14:00',
                                                                      end_date:   '2022-02-21T15:00',
                                                                      location:   'ETH Zurich'
                                                                    }]
                                                                  }).model.reload
          end

          def test_only_title
            event = fetch(:event)

            # Check that the title is still the initial
            assert_equal 'Testpost', event.title

            # Update the title
            ::Operations::Admin::Event::Update.run!(id: event.id, event: { title: 'New post title' })

            # Reload event
            event.reload

            # Check that the title has changed
            assert_equal 'New post title', event.title
          end

          def test_all_attrs
            event = fetch(:event)

            # Check that the attrs are still the initial
            assert_equal 'Testpost', event.title
            assert event.published?
            assert_equal 'A fun event', event.description
            assert_equal 1, event.event_dates.count

            # Update the event
            ::Operations::Admin::Event::Update.run!(id: event.id, event: {
                                                      title:       'New post title',
                                                      published:   false,
                                                      description: 'A fun and cool event'
                                                    })

            # Reload event
            event.reload

            # Check that the attrs have changed
            assert_equal 'New post title', event.title
            assert_not event.published?
            assert_equal 'A fun and cool event', event.description
            assert_equal 1, event.event_dates.count
          end
        end
      end
    end
  end
end
