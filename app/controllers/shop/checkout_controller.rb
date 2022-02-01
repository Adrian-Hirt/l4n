module Shop
  class CheckoutController < ShopController
    def show
      run Operations::Shop::Order::PrepareCheckout
    rescue Operations::Shop::Order::PrepareCheckout::CartEmpty
      flash[:danger] = _('Checkout|Your cart is empty, cannot checkout')
      redirect_to shop_cart_path
    rescue Operations::Shop::Order::PrepareCheckout::MaxQuantityReached
      redirect_to shop_cart_path
    end
  end
end
