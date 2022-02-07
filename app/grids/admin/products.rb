module Grids
  module Admin
    class Products < ApplicationGrid
      include Datagrid

      scope do
        Product.order(:name)
      end

      model Product

      column :id
      column :name
      column :on_sale, html: ->(on_sale) { format_boolean(on_sale) }
      column :product_variants_count, html: true do |product|
        product.product_variants.count
      end
      column :'datagrid-actions', html: true, header: false do |product|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(product, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(product, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
