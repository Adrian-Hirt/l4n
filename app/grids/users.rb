module Grids
  class Users < ApplicationGrid
    scope do
      ::User.order(:created_at)
    end

    model ::User

    column :avatar, html: true do |user|
      if user.avatar.attached?
        image_tag user.avatar.variant(:thumb).processed, class: 'avatar-thumb'
      else
        tag.div(class: 'avatar-thumb-placeholder')
      end
    end
    column :username
    column :created_at
    column :'datagrid-actions', html: true, header: false do |user|
      show_button(user, size: :sm, icon_only: true)
    end

    filter(:username, :string) do |value|
      sanitized_value = sanitize_sql_like(value.downcase)
      where('LOWER(username) LIKE ?', "%#{sanitized_value}%")
    end
  end
end
