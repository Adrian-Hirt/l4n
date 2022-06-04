module Shop
  class HomeController < ShopController
    skip_before_action :require_logged_in_user

    def index
      op Operations::Shop::Home::Index
    end
  end
end
