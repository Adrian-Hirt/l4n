module Shop
  class ProductVariantsController < ShopController
    def add_to_cart
      if run Operations::Shop::ProductVariant::AddToCart
        flash[:success] = _('ProductVariant|Successfully added to cart')
      else
        flash[:danger] = _('ProductVariant|Could not be added to cart')
      end
      redirect_to shop_product_path(model.product)
    rescue Operations::Shop::ProductVariant::MaxQuantityReached
      flash[:danger] = _('ProductVariant|Max quantity reached')
      redirect_to shop_product_path(model.product)
    end
  end
end
