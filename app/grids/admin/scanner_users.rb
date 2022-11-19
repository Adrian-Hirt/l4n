module Grids
  module Admin
    class ScannerUsers < ApplicationGrid
      scope do
        ScannerUser.order(:id)
      end

      model ScannerUser

      column :name
      column :lan_party, html: -> (lan_party) { lan_party.name }
      column :'datagrid-actions', html: true, header: false do |scanner_user|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(scanner_user, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(scanner_user, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
