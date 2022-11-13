module Grids
  module Admin
    class SidebarBlocks < ApplicationGrid
      scope do
        SidebarBlock.order(:sort)
      end

      model SidebarBlock

      column :title
      column :sort
      column :visible, html: ->(visible) { format_boolean visible }
      column :'datagrid-actions', html: true, header: false do |sidebar_block|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(sidebar_block, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(sidebar_block, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
