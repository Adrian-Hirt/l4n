module Shop
  class ProductsController < ShopController
    skip_before_action :require_logged_in_user

    def show
      run Operations::Shop::Product::Load
    end
  end
end
