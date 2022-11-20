module Grids
  module Admin
    class UserAchievements < ApplicationGrid
      scope do
        UserAchievement
      end

      model UserAchievement

      column :user, html: ->(user) { user.username }
      column :awarded_at, html: ->(awarded_at) { l awarded_at }

      column :'datagrid-actions', html: true, header: false do |achievement_user|
        tag.div class: %i[datagrid-actions-wrapper] do
          delete_button(achievement_user, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end

      filter(:achievement)
    end
  end
end
