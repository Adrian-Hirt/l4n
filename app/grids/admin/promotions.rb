module Grids
  module Admin
    class Promotions < ApplicationGrid
      scope do
        Promotion.order(:name)
      end

      model Promotion

      column :id
      column :name
      column :active, html: ->(active) { format_boolean(active) }
      column :code_type
      column :'datagrid-actions', html: true, header: false do |promotion|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(promotion, namespace: %i[admin shop], size: :sm, icon_only: true),
                      edit_button(promotion, namespace: %i[admin shop], size: :sm, icon_only: true),
                      delete_button(promotion, namespace: %i[admin shop], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
