module Shop
  class CartController < ShopController
    def index
      run Operations::Shop::Cart::Show
      flash[:danger] = _('Cart|Some items are not available in the requested quantity, please check below') if op.availability_error
    end
  end
end
