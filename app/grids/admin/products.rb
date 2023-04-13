module Grids
  module Admin
    class Products < ApplicationGrid
      scope do
        Product.order(:name).includes(:product_category).where(archived: false)
      end

      model Product

      SELECT_OPTIONS = [
        [_('Product|Exclude archived'), false],
        [_('Product|Show all'), true]
      ].freeze

      column :name
      column :sort
      column :product_category, html: ->(product_category) { product_category.name }
      column :on_sale, html: ->(on_sale) { format_boolean(on_sale) }
      column :archived, html: ->(archived) { format_boolean(archived) }
      column :product_variants_count, html: true do |product|
        product.product_variants.count
      end
      column :'datagrid-actions', html: true, header: false do |product|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(product, namespace: %i[admin shop], size: :sm, icon_only: true),
                      delete_button(product, namespace: %i[admin shop], size: :sm, icon_only: true, disabled: !product.deleteable?)
                    ])
        end
      end

      filter(:include_archived, :enum, select: SELECT_OPTIONS, include_blank: false) do |value, scope|
        value = value.blank? ? nil : ::Datagrid::Utils.booleanize(value)

        scope = scope.unscope(where: :archived) unless value.is_a?(FalseClass)

        scope
      end
    end
  end
end
