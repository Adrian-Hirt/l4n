module Grids
  module Admin
    class Tournaments < ApplicationGrid
      scope do
        Tournament.order(:id)
      end

      model Tournament

      column :name
      column :status, html: true do |tournament|
        format_tournament_status(tournament)
      end
      column :registration_open, html: true do |tournament|
        format_registration_status(tournament)
      end
      column :'datagrid-actions', html: true, header: false do |tournament|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(tournament, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end

      filter(:status, :enum, select: Tournament.statuses.keys, include_blank: _('Form|Select|Show all'))
    end
  end
end
