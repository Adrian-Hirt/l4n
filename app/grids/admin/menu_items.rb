module Grids
  module Admin
    class MenuItems < ApplicationGrid
      include Datagrid

      scope do
        MenuItem.all
      end

      model MenuItem

      column :title
      column :page_name
      column :sort
      column :parent, html: ->(parent) { parent&.name || '-' }
      column :'datagrid-actions', html: true, header: false do |menu_item|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(menu_item, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(menu_item, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
