module Shop
  class HomeController < ShopController
    def index
      op Operations::Shop::Home::Index
    end
  end
end
