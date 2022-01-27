module Shop
  class CheckoutController < ShopController
    def show
      run Operations::Shop::Order::PrepareCheckout
    rescue Operations::Shop::Order::PrepareCheckout::CartEmpty
      flash[:danger] = _('Checkout|Your cart is empty, cannot checkout')
      redirect_to shop_cart_path
    end

    def start
      if run Operations::Shop::Order::StartCheckout
        redirect_to op.payment_path
      else
        flash[:danger] = _('Checkout|Checkout failed, please try again')
        redirect_to shop_checkout_path
      end
    end

    def payment_callback; end
  end
end
