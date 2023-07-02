module Grids
  module Admin
    class StylingVariables < ApplicationGrid
      scope do
        StylingVariable.order(:key)
      end

      model StylingVariable

      column :key
      column :light_mode_value
      column :dark_mode_value
      column :'datagrid-actions', html: true, header: false do |styling_variable|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(styling_variable, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(styling_variable, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
