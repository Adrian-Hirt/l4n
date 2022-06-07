module Admin
  class ProductCategoriesController < AdminController
    add_breadcrumb _('Admin|ProductCategories'), :admin_product_categories_path

    def index
      op Operations::Admin::ProductCategory::Index
    end

    def show
      op Operations::Admin::ProductCategory::Load
      add_breadcrumb model.name
    end

    def new
      add_breadcrumb _('Admin|ProductCategory|New')
      op Operations::Admin::ProductCategory::Create
    end

    def create
      if run Operations::Admin::ProductCategory::Create
        flash[:success] = _('Admin|ProductCategory|Successfully created')
        redirect_to admin_product_categories_path
      else
        add_breadcrumb _('Admin|ProductCategory|New')
        flash[:danger] = _('Admin|ProductCategory|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::ProductCategory::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::ProductCategory::Update
        flash[:success] = _('Admin|ProductCategory|Successfully updated')
        redirect_to admin_product_categories_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|ProductCategory|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::ProductCategory::Destroy
        flash[:success] = _('Admin|ProductCategory|Successfully deleted')
      else
        flash[:danger] = _('Admin|ProductCategory|Cannot be deleted')
      end
      redirect_to admin_product_categories_path
    end
  end
end
