module Grids
  module Admin
    class Products < ApplicationGrid
      scope do
        Product.order(:name).includes(:product_category)
      end

      model Product

      column :name
      column :sort
      column :product_category, html: ->(product_category) { product_category.name }
      column :on_sale, html: ->(on_sale) { format_boolean(on_sale) }
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
    end
  end
end
