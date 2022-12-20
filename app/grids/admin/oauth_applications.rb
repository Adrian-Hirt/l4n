module Grids
  module Admin
    class OauthApplications < ApplicationGrid
      scope do
        ::Doorkeeper::Application.ordered_by(:created_at)
      end

      model ::Doorkeeper::Application

      column :name
      column :redirect_uris, html: true do |m|
        simple_format(m.redirect_uri, class: 'mb-0')
      end
      column :confidential, html: ->(confidential) { format_boolean confidential }
      column :'datagrid-actions', html: true, header: false do |oauth_application|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(oauth_application, size: :sm, icon_only: true, href: oauth_application_path(oauth_application)),
                      edit_button(oauth_application, size: :sm, icon_only: true, href: edit_oauth_application_path(oauth_application)),
                      delete_button(oauth_application, size: :sm, icon_only: true, href: oauth_application_path(oauth_application))
                    ])
        end
      end
    end
  end
end
