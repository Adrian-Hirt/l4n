module Grids
  module Admin
    class PromotionCodes < ApplicationGrid
      scope do
        PromotionCode.includes(promotion_code_mapping: :order).order(:id)
      end

      model PromotionCode

      SELECT_OPTIONS = [
        [_('PromotionCodes|Show only used'), true],
        [_('PromotionCodes|Show only unused'), false],
        [_('PromotionCodes|Show all'), nil]
      ].freeze

      column :code
      column :used, html: true, order: false do |promotion_code|
        format_boolean(promotion_code.used?)
      end

      column :used_for_order, html: true do |promotion_code|
        link_to(promotion_code.order.formatted_id, admin_shop_order_path(promotion_code.order)) if promotion_code.order.present?
      end
      column :'datagrid-actions', html: true, header: false do |promotion_code|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      delete_button(promotion_code,
                                    namespace: %i[admin shop],
                                    size:      :sm,
                                    icon_only: true,
                                    disabled:  promotion_code.promotion_code_mapping.present?)
                    ])
        end
      end

      filter(:promotion)

      filter(:used, :enum, select: SELECT_OPTIONS, include_blank: false) do |value, scope|
        scope = scope.joins('LEFT OUTER JOIN promotion_code_mappings ON promotion_codes.id = promotion_code_mappings.promotion_code_id')

        value = value.blank? ? nil : ::Datagrid::Utils.booleanize(value)

        if value
          scope = scope.where.not(promotion_code_mappings: { id: nil })
        else
          scope = scope.where(promotion_code_mappings: { id: nil })
        end

        scope
      end
    end
  end
end
