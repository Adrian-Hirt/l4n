module Grids
  module Admin
    class SeatCategories < ApplicationGrid
      scope do
        SeatCategory.order(:name)
      end

      model SeatCategory

      column :name
      column :relevant_for_counter, html: ->(relevant_for_counter) { format_boolean(relevant_for_counter) }
      column :seat_count, html: true do |seat_category|
        seat_category.seats.count
      end
      column :color, html: true do |seat_category|
        tag.div style: "background-color: #{seat_category.color_for_view}; height: 1rem; width: 100px;"
      end
      column :'datagrid-actions', html: true, header: false do |seat_category|
        if can? :manage, LanParty
          tag.div class: %i[datagrid-actions-wrapper] do
            safe_join([
                        edit_button(seat_category, namespace: %i[admin], size: :sm, icon_only: true),
                        delete_button(seat_category, namespace: %i[admin], size: :sm, icon_only: true)
                      ])
          end
        end
      end

      filter(:lan_party)
    end
  end
end
