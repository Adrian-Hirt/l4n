module Grids
  module Admin
    class SeatCategories < ApplicationGrid
      scope do
        SeatCategory.all
      end

      model SeatCategory

      column :id
      column :name
      column :'datagrid-actions', html: true, header: false do |seat_category|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(seat_category, namespace: %i[admin], size: :sm, icon_only: true),
                      edit_button(seat_category, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(seat_category, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end

      filter(:lan_party)
    end
  end
end
