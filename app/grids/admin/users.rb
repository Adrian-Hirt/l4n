module Grids
  module Admin
    class Users
      include Datagrid

      scope do
        User.all
      end

      column :id, header: _('User|Id')
      column :username, header: _('User|Username')
      column :email, header: _('User|Email')
      column :activated, html: ->(activated) { format_boolean(activated) }, header: _('User|Activated')
      column :'datagrid-actions', html: true, header: '' do |user|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(user, namespace: %i[admin], size: :sm, icon_only: true),
                      edit_button(user, href: profile_admin_user_path(user), size: :sm, icon_only: true),
                      delete_button(user, namespace: %i[admin], size: :sm, icon_only: true, disabled: user == current_user)
                    ])
        end
      end
    end
  end
end
