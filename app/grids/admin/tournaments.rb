module Grids
  module Admin
    class Tournaments < ApplicationGrid
      scope do
        Tournament.order(:id)
      end

      model Tournament

      column :id
      column :name
      column :'datagrid-actions', html: true, header: false do |tournament|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(tournament, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
