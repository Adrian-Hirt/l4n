module Grids
  module Admin
    class ContentPages < ApplicationGrid
      scope do
        ContentPage.order(:url)
      end

      model ContentPage

      pagination_param :content_page

      column :url
      column :title
      column :published, html: ->(published) { format_boolean(published) }
      column :use_sidebar, html: ->(use_sidebar) { format_boolean(use_sidebar) }
      column :'datagrid-actions', html: true, header: false do |page|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(page, href: edit_admin_page_path(page), size: :sm, icon_only: true),
                      delete_button(page, href: admin_page_path(page), size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
