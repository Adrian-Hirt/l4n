module Grids
  module Admin
    class FooterLogos < ApplicationGrid
      scope do
        FooterLogo.order(:sort)
      end

      model FooterLogo

      column :logo_file, html: true do |footer_logo|
        image_tag footer_logo.file.variant(:thumb).processed
      end
      column :sort
      column :visible, html: ->(visible) { format_boolean visible }
      column :link
      column :'datagrid-actions', html: true, header: false do |footer_logo|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(footer_logo, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(footer_logo, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
