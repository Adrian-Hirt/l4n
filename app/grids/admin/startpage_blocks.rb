module Grids
  module Admin
    class StartpageBlocks < ApplicationGrid
      scope do
        StartpageBlock.order(:sort)
      end

      model StartpageBlock

      column :title
      column :sort
      column :visible, html: ->(visible) { format_boolean visible }
      column :'datagrid-actions', html: true, header: false do |startpage_block|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(startpage_block, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(startpage_block, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
