module Grids
  module Admin
    class RedirectPages < ApplicationGrid
      scope do
        RedirectPage.order(:url)
      end

      model RedirectPage

      pagination_param :redirect_page

      column :url
      column :redirects_to
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
