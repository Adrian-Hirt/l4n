module Admin
  module Shop
    class ProductsController < AdminController
      add_breadcrumb _('Admin|Products'), :admin_shop_products_path

      def index
        op Operations::Admin::Product::Index
      end

      def new
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Product') }
        op Operations::Admin::Product::Create
      end

      def create
        if run Operations::Admin::Product::Create
          flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Product') }
          redirect_to admin_shop_products_path
        else
          add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Product') }
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Product') }
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::Product::Update
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Product::Update
          flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Product') }
          redirect_to admin_shop_product_path(model)
        else
          add_breadcrumb model.name
          flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Product') }
          render :edit, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotDestroyed
        add_breadcrumb model.name
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Product') }
        render :edit, status: :unprocessable_entity
      end

      def destroy
        if run Operations::Admin::Product::Destroy
          flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Product') }
        else
          flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Product') }
        end
        redirect_to admin_shop_products_path
      rescue ActiveRecord::RecordNotDestroyed
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Product') }
        redirect_to admin_shop_products_path
      end
    end
  end
end
