module Shop
  class OrdersController < ShopController
    def index
      op Operations::Shop::Order::Index
    end

    def show
      op Operations::Shop::Order::Load
    end
  end
end
