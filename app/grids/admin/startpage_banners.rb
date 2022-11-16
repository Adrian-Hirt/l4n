module Grids
  module Admin
    class StartpageBanners < ApplicationGrid
      scope do
        StartpageBanner.order(:name)
      end

      model StartpageBanner

      column :name
      column :visible, html: ->(visible) { format_boolean visible }
      column :height
      column :images, html: true do |startpage_banner|
        startpage_banner.images.count
      end
      column :'datagrid-actions', html: true, header: false do |startpage_banner|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(startpage_banner, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(startpage_banner, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
