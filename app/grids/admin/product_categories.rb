module Grids
  module Admin
    class ProductCategories < ApplicationGrid
      scope do
        ProductCategory.includes(:products).order(:name)
      end

      model ProductCategory

      column :id
      column :name
      column :sort
      column :products_count, html: true do |product_category|
        product_category.products.count
      end
      column :'datagrid-actions', html: true, header: false do |product_category|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(product_category, namespace: %i[admin], size: :sm, icon_only: true),
                      edit_button(product_category, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(product_category, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
