module Grids
  module Admin
    class Users < ApplicationGrid
      scope do
        User.order(:id)
      end

      model User

      column :username
      column :email
      column :confirmed, html: true, header: _('User|Confirmed') do |user|
        format_boolean user.confirmed?
      end
      column :'datagrid-actions', html: true, header: false do |user|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(user, size: :sm, icon_only: true),
                      edit_button(user, href: profile_admin_user_path(user), size: :sm, icon_only: true),
                      delete_button(user, namespace: %i[admin], size: :sm, icon_only: true, disabled: !user.deleteable? || user == current_user)
                    ])
        end
      end

      filter(:email, :string) do |value|
        sanitized_value = sanitize_sql_like(value.downcase)
        where('LOWER(email) LIKE ?', "%#{sanitized_value}%")
      end

      filter(:username, :string) do |value|
        sanitized_value = sanitize_sql_like(value.downcase)
        where('LOWER(username) LIKE ?', "%#{sanitized_value}%")
      end
    end
  end
end
