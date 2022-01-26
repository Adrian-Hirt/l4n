module Shop
  class CheckoutController < ShopController
    def show
      run Operations::Shop::Order::PrepareCheckout
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
