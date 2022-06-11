module Grids
  module Admin
    class PromotionCodes < ApplicationGrid
      scope do
        PromotionCode.order(:id)
      end

      model PromotionCode

      column :code
      column :used, html: true do |promotion_code|
        format_boolean(promotion_code.order.present?)
      end
      column :used_for_order, html: true do |promotion_code|
        link_to(promotion_code.order.formatted_id, admin_shop_order_path(promotion_code.order)) if promotion_code.order.present?
      end
      # column :'datagrid-actions', html: true, header: false do |promotion_code|
      #   tag.div class: %i[datagrid-actions-wrapper] do
      #     safe_join([
      #                 delete_button(promotion_code, namespace: %i[admin shop], size: :sm, icon_only: true)
      #               ])
      #   end
      # end

      filter(:promotion)
    end
  end
end
