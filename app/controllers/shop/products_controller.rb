module Shop
  class ProductsController < ShopController
    def show
      op Operations::Shop::Product::Load
    end
  end
end
