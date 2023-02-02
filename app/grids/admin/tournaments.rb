module Grids
  module Admin
    class Tournaments < ApplicationGrid
      scope do
        Tournament.order(id: :desc).includes(:lan_party)
      end

      model Tournament

      column :name
      column :lan_party, html: true do |tournament|
        link_to tournament.lan_party.name, admin_lan_party_path(tournament.lan_party) if tournament.lan_party.present?
      end
      column :frontend_order
      column :status, html: true do |tournament|
        format_tournament_status(tournament)
      end
      column :registration_open, html: true do |tournament|
        format_registration_status(tournament)
      end
      column :'datagrid-actions', html: true, header: false do |tournament|
        tag.div class: %i[datagrid-actions-wrapper] do
          if can?(:destroy, Tournament)
            safe_join([
                        show_button(tournament, namespace: %i[admin], size: :sm, icon_only: true),
                        delete_button(tournament, namespace: %i[admin], size: :sm, icon_only: true)
                      ])
          else
            show_button(tournament, namespace: %i[admin], size: :sm, icon_only: true)
          end
        end
      end

      filter(:status, :enum, select: Tournament.statuses.keys.map { |status| [humanize_enum_for_select(Tournament, :status, status), status] }, include_blank: _('Form|Select|Show all'))
      filter(:lan_party, :enum, select:        LanParty.where(id: scope.pluck(:lan_party_id)).order(:name).map { |lan_party| [lan_party.name, lan_party.id] },
                                include_blank: _('Form|Select|Show all'))
    end
  end
end
