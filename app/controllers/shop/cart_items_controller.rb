module Shop
  class CartItemsController < ShopController
    def destroy
      if run Operations::Shop::CartItem::Destroy
        flash[:success] = _('CartItem|Successfully deleted')
      else
        flash[:danger] = _('CartItem|Cannot be deleted')
      end
      redirect_to shop_cart_path
    end

    def increase_quantity
      if run Operations::Shop::CartItem::IncreaseQuantity
        flash[:success] = _('CartItem|Successfully increased quantity')
      else
        flash[:danger] = _('CartItem|Quantity cannod be increased')
      end
      redirect_to shop_cart_path
    rescue Operations::Shop::CartItem::MaxQuantityReached
      flash[:danger] = _('CartItem|Quantity cannod be increased')
      redirect_to shop_cart_path
    end

    def decrease_quantity
      if run Operations::Shop::CartItem::DecreaseQuantity
        flash[:success] = _('CartItem|Successfully decreased quantity')
      else
        flash[:danger] = _('CartItem|Quantity cannot be decreased')
      end
      redirect_to shop_cart_path
    end
  end
end
