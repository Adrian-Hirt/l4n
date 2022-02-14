module Grids
  module Admin
    class LanParties < ApplicationGrid
      scope do
        LanParty.all
      end

      model LanParty

      column :id
      column :name
      column :'datagrid-actions', html: true, header: false do |lan_party|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(lan_party, namespace: %i[admin], size: :sm, icon_only: true),
                      edit_button(lan_party, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(lan_party, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
