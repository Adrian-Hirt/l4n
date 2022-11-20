module Grids
  module Admin
    class LanParties < ApplicationGrid
      scope do
        LanParty.order(id: :desc)
      end

      model LanParty

      column :active, html: ->(active) { format_boolean(active) }
      column :name
      column :'datagrid-actions', html: true, header: false do |lan_party|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(lan_party, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end
    end
  end
end
