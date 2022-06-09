module Shop
  class CheckoutController < ShopController
    def show
      run! Operations::Shop::Order::PrepareCheckout
    rescue Operations::Shop::Order::PrepareCheckout::CartEmpty
      flash[:danger] = _('Checkout|Your cart is empty, cannot checkout')
      redirect_to shop_cart_path
    rescue Operations::Shop::Order::PrepareCheckout::MaxQuantityReached
      redirect_to shop_cart_path
    end

    def set_address
      run Operations::Shop::Order::SetOrderAddress

      respond_to do |format|
        format.turbo_stream
      end
    end

    def use_promotion_code
      run Operations::Shop::Order::UsePromotionCode
    rescue Operations::Shop::Order::InvalidPromotionCode
      @code_error = _('Checkout|Your promotion code is invalid or already used!')
    rescue Operations::Shop::Order::PromoCodeLimitReached
      @code_error = _('Checkout|You have reached the max number of codes for this order!')
    rescue Operations::Shop::Order::PromoCodeCannotBeApplied
      @code_error = _('Checkout|The promotion code cannot be applied!')
    rescue Operations::Shop::Order::PromoCodeAlreadyApplied
      @code_error = _('Checkout|The promotion code is already applied to this order!')
    ensure
      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
