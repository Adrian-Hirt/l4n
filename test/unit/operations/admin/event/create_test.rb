require 'test_helper'

module Unit
  module Operations
    module Admin
      module Event
        class CreateTest < ApplicationTest
          def test_only_title
            assert_no_difference '::Event.count' do
              assert_raises ActiveRecord::RecordInvalid do
                ::Operations::Admin::Event::Create.run!(event: { title: 'Testpost' }).model.reload
              end
            end
          end

          def test_title_and_one_date
            assert_difference '::Event.count', +1 do
              event = ::Operations::Admin::Event::Create.run!(event: {
                                                                title:                  'Testpost',
                                                                event_dates_attributes: [{
                                                                  start_date: '2022-02-20T14:00',
                                                                  end_date:   '2022-02-21T15:00'
                                                                }]
                                                              }).model.reload

              assert_equal 'Testpost', event.title
              assert event.location.blank?
              assert_not event.published
              assert_nil event.description
              assert_equal 1, event.event_dates.count
            end
          end

          def test_all_attrs
            assert_difference '::Event.count', +1 do
              event = ::Operations::Admin::Event::Create.run!(event: {
                                                                title:                  'Testpost',
                                                                location:               'ETH Zurich',
                                                                published:              true,
                                                                description:            'A fun event',
                                                                event_dates_attributes: [{
                                                                  start_date: '2022-02-20T14:00',
                                                                  end_date:   '2022-02-21T15:00'
                                                                }]
                                                              }).model.reload

              assert_equal 'Testpost', event.title
              assert_equal 'ETH Zurich', event.location
              assert event.published?
              assert_equal 'A fun event', event.description
              assert_equal 1, event.event_dates.count
            end
          end
        end
      end
    end
  end
end
