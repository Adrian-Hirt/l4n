module Shop
  class CartController < ShopController
    add_breadcrumb _('Cart')

    def index
      run Operations::Shop::Cart::Show
      flash[:danger] = _('Cart|Some items are not available in the requested quantity, please check below') if op.availability_error
    end
  end
end
