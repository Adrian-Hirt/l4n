module Shop
  class CartController < ShopController
    def index
      run Operations::Shop::Cart::Show
      flash[:danger] = format(_('Cart|The following items had their quantity reduced: %{items}'), items: op.reduced_cart_items.join(', ')).to_s if op.reduced_cart_items.any?
      flash[:danger] = format(_('Cart|The following items were removed: %{items}'), items: op.removed_cart_items.join(', ')).to_s if op.removed_cart_items.any?
    end
  end
end
