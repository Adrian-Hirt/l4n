module Shop
  class ProductsController < ShopController
    def show
      run Operations::Shop::Product::Load
    end
  end
end
