module Admin
  module Shop
    class ProductsController < AdminController
      add_breadcrumb _('Admin|Products'), :admin_shop_products_path

      def index
        op Operations::Admin::Product::Index
      end

      def new
        add_breadcrumb _('Admin|Product|New')
        op Operations::Admin::Product::Create
      end

      def create
        if run Operations::Admin::Product::Create
          flash[:success] = _('Admin|Product|Successfully created')
          redirect_to admin_shop_products_path
        else
          add_breadcrumb _('Admin|Product|New')
          flash[:danger] = _('Admin|Product|Create failed')
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::Product::Update
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Product::Update
          flash[:success] = _('Admin|Product|Successfully updated')
          redirect_to admin_shop_product_path(model)
        else
          add_breadcrumb model.name
          flash[:danger] = _('Admin|Product|Edit failed')
          render :edit, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotDestroyed
        add_breadcrumb model.name
        flash[:danger] = _('Admin|Product|Edit failed')
        render :edit, status: :unprocessable_entity
      end

      def destroy
        if run Operations::Admin::Product::Destroy
          flash[:success] = _('Admin|Product|Successfully deleted')
        else
          flash[:danger] = _('Admin|Product|Cannot be deleted')
        end
        redirect_to admin_shop_products_path
      rescue ActiveRecord::RecordNotDestroyed
        flash[:danger] = _('Admin|Product|Cannot be deleted')
        redirect_to admin_shop_products_path
      end
    end
  end
end
