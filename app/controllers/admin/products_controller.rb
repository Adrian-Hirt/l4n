module Admin
  class ProductsController < AdminController
    add_breadcrumb _('Admin|Products'), :admin_products_path

    def index
      op Operations::Admin::Product::Index
    end

    def new
      add_breadcrumb _('Admin|Products|New')
      op Operations::Admin::Product::Create
    end

    def create
      if run Operations::Admin::Product::Create
        flash[:success] = _('Product|Successfully created')
        redirect_to admin_products_path
      else
        add_breadcrumb _('Admin|Products|New')
        flash[:danger] = _('Product|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Product::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::Product::Update
        flash[:success] = _('Product|Successfully updated')
        redirect_to admin_product_path(model)
      else
        add_breadcrumb model.name
        flash[:danger] = _('Product|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Product::Destroy
        flash[:success] = _('Product|Successfully deleted')
      else
        flash[:danger] = _('Product|Cannot be deleted')
      end
      redirect_to admin_products_path
    end
  end
end
