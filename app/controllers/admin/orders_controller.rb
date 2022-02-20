module Admin
  class OrdersController < AdminController
    add_breadcrumb _('Admin|Orders'), :admin_orders_path

    def index
      op Operations::Admin::Order::Index
    end

    def show
      op Operations::Admin::Order::Load
      add_breadcrumb model.formatted_id, nil
    end
  end
end
