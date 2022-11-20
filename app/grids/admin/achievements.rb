module Grids
  module Admin
    class Achievements < ApplicationGrid
      scope do
        Achievement.order(:id)
      end

      model Achievement

      column :title
      column :icon, html: true do |achievement|
        image_tag achievement.icon.variant(:small).processed if achievement.icon.attached?
      end

      column :'datagrid-actions', html: true, header: false do |achievement|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(achievement, namespace: %i[admin], size: :sm, icon_only: true),
                      edit_button(achievement, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(achievement, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
