module Admin
  class HomeController < AdminController
    def dashboard
      if current_user.only_payment_assist_permission?
        redirect_to admin_shop_payment_assist_path
      end
    end
  end
end
