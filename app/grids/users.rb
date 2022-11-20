module Grids
  class Users < ApplicationGrid
    scope do
      ::User.order(:created_at)
    end

    model ::User

    column :avatar, html: true do |user|
      if user.avatar.attached?
        image_tag user.avatar.variant(:thumb).processed
      else
        tag.div(class: 'avatar-thumb-placeholder')
      end
    end
    column :username
    column :created_at
    column :'datagrid-actions', html: true, header: false do |user|
      show_button(user, size: :sm, icon_only: true)
    end
  end
end
