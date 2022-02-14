module Grids
  module Admin
    class Pages < ApplicationGrid
      scope do
        Page.order(:title)
      end

      model Page

      column :title
      column :published, html: ->(published) { format_boolean(published) }
      column :url
      column :'datagrid-actions', html: true, header: false do |page|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(page, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(page, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
