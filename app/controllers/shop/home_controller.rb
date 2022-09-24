module Shop
  class HomeController < ShopController
    skip_before_action :authenticate_user!

    def index
      op Operations::Shop::Home::Index
    end
  end
end
