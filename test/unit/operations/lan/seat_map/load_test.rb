require 'test_helper'

module Unit
  module Operations
    module Lan
      module Timetable
        class LoadTest < ApplicationTest
          setup do
            store :lan_party_1, create_lan_party(active: false, timetable_enabled: true)
            store :lan_party_2, create_lan_party(active: false, timetable_enabled: true)
            store :user, create_user
          end

          def test_lan_party_not_active
            assert_raises CanCan::AccessDenied do
              as_user fetch(:user) do
                build_op ::Operations::Lan::Timetable::Load, id: fetch(:lan_party_1).id
              end
            end

            assert_raises CanCan::AccessDenied do
              as_user fetch(:user) do
                build_op ::Operations::Lan::Timetable::Load, id: fetch(:lan_party_2).id
              end
            end
          end

          def test_other_lan_party_active
            fetch(:lan_party_2).update(active: true)

            assert_raises CanCan::AccessDenied do
              as_user fetch(:user) do
                build_op ::Operations::Lan::Timetable::Load, id: fetch(:lan_party_1).id
              end
            end

            as_user fetch(:user) do
              timetable = build_op(::Operations::Lan::Timetable::Load, id: fetch(:lan_party_2).id).model
              assert_equal fetch(:lan_party_2).timetable, timetable
            end
          end

          def test_both_lan_parties_active
            fetch(:lan_party_1).update(active: true)
            fetch(:lan_party_2).update(active: true)

            as_user fetch(:user) do
              timetable = build_op(::Operations::Lan::Timetable::Load, id: fetch(:lan_party_1).id).model
              assert_equal fetch(:lan_party_1).timetable, timetable
            end

            as_user fetch(:user) do
              timetable = build_op(::Operations::Lan::Timetable::Load, id: fetch(:lan_party_2).id).model
              assert_equal fetch(:lan_party_2).timetable, timetable
            end

            assert_not_equal fetch(:lan_party_1).timetable, fetch(:lan_party_2).timetable
          end

          def test_active_but_timetable_not_enabled
            fetch(:lan_party_1).update(active: true, timetable_enabled: false)

            assert_raises CanCan::AccessDenied do
              as_user fetch(:user) do
                build_op ::Operations::Lan::Timetable::Load, id: fetch(:lan_party_1).id
              end
            end
          end

          def test_id_not_found
            assert_raises ActiveRecord::RecordNotFound do
              as_user fetch(:user) do
                build_op ::Operations::Lan::Timetable::Load, id: 0
              end
            end
          end
        end
      end
    end
  end
end
