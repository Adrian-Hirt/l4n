module Grids
  module Admin
    class PromotionCodes < ApplicationGrid
      scope do
        PromotionCode.order(:id)
      end

      model PromotionCode

      column :code
      column :used, html: ->(used) { format_boolean(used) }
      # column :'datagrid-actions', html: true, header: false do |promotion_code|
      #   tag.div class: %i[datagrid-actions-wrapper] do
      #     safe_join([
      #                 delete_button(promotion_code, namespace: %i[admin shop], size: :sm, icon_only: true)
      #               ])
      #   end
      # end
    end
  end
end
