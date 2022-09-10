module Grids
  module Admin
    class Tournaments < ApplicationGrid
      scope do
        Tournament.order(:id)
      end

      model Tournament

      column :id
      column :name
      column :status
      column :registration_open, html: true do |tournament|
        format_registration_status(tournament)
      end
      column :'datagrid-actions', html: true, header: false do |tournament|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(tournament, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end
    end
  end
end
