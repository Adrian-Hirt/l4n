module Grids
  module Admin
    class Users < ApplicationGrid
      scope do
        User.includes(:user_permissions).order(:id)
      end

      model User

      column :username
      column :email
      column :confirmed, html: true, header: _('User|Confirmed') do |user|
        format_boolean user.confirmed?
      end
      column :permissions_count do |user|
        user.user_permissions.count
      end
      column :otp_required_for_login, html: true, header: _('User|2FA enabled?'), order: false do |user|
        format_boolean user.otp_required_for_login?
      end
      column :'datagrid-actions', html: true, header: false do |user|
        tag.div class: %i[datagrid-actions-wrapper] do
          if can? :manage, User
            safe_join([
                        show_button(user, size: :sm, icon_only: true),
                        edit_button(user, href: profile_admin_user_path(user), size: :sm, icon_only: true),
                        delete_button(user, namespace: %i[admin],
                                            size: :sm,
                                            icon_only: true,
                                            disabled: !user.deleteable? || user == current_user,
                                            confirm: _('Admin|User|Long user delete confirm message for %{username}') %  { username: user.username })
                      ])
          else
            show_button(user, size: :sm, icon_only: true)
          end
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
