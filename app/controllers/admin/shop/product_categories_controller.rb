module Admin
  module Shop
    class ProductCategoriesController < AdminController
      add_breadcrumb _('Admin|ProductCategories'), :admin_shop_product_categories_path

      def index
        op Operations::Admin::ProductCategory::Index
      end

      def show
        op Operations::Admin::ProductCategory::Load
        add_breadcrumb model.name
      end

      def new
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('ProductCategory') }
        op Operations::Admin::ProductCategory::Create
      end

      def create
        if run Operations::Admin::ProductCategory::Create
          flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('ProductCategory') }
          redirect_to admin_shop_product_categories_path
        else
          add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('ProductCategory') }
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('ProductCategory') }
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::ProductCategory::Update
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::ProductCategory::Update
          flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('ProductCategory') }
          redirect_to admin_shop_product_categories_path
        else
          add_breadcrumb model.name
          flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('ProductCategory') }
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::ProductCategory::Destroy
          flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('ProductCategory') }
        else
          flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('ProductCategory') }
        end
        redirect_to admin_shop_product_categories_path
      end
    end
  end
end
