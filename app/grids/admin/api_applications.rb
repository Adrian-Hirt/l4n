module Grids
  module Admin
    class ApiApplications < ApplicationGrid
      scope do
        ApiApplication.all
      end

      model ApiApplication

      column :id
      column :name
      column :'datagrid-actions', html: true, header: false do |api_application|
        tag.div class: %i[datagrid-actions-wrapper] do
          if can?(:manage, ApiApplication)
            safe_join([
                        show_button(api_application, namespace: %i[admin], size: :sm, icon_only: true),
                        edit_button(api_application, namespace: %i[admin], size: :sm, icon_only: true),
                        delete_button(api_application, namespace: %i[admin], size: :sm, icon_only: true)
                      ])
          else
            show_button(api_application, namespace: %i[admin], size: :sm, icon_only: true)
          end
        end
      end
    end
  end
end
