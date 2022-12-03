module Admin
  class HomeController < AdminController
    def dashboard
      redirect_to admin_shop_payment_assist_path if current_user.only_payment_assist_permission?
    end
  end
end
