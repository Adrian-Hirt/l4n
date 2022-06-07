module Admin
  module Shop
    class DashboardController < AdminController
      add_breadcrumb _('Admin|Shop|Dashboard'), :admin_shop_dashboard_path

      def index; end
    end
  end
end
