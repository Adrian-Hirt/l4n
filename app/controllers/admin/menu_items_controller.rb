module Admin
  class MenuItemsController < AdminController
    add_breadcrumb _('Admin|MenuItem'), :admin_menu_items_path

    def index
      op Operations::Admin::MenuItem::Index
    end

    def new
      add_breadcrumb _('Admin|MenuItem|New')
      op Operations::Admin::MenuItem::Create
    end

    def create
      if run Operations::Admin::MenuItem::Create
        flash[:success] = _('MenuItem|Successfully created')
        redirect_to admin_menu_items_path
      else
        add_breadcrumb _('Admin|MenuItem|New')
        flash[:danger] = _('MenuItem|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::MenuItem::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::MenuItem::Update
        flash[:success] = _('MenuItem|Successfully updated')
        redirect_to admin_menu_items_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('MenuItem|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::MenuItem::Destroy
        flash[:success] = _('MenuItem|Successfully deleted')
      else
        flash[:danger] = _('MenuItem|Cannot be deleted')
      end
      redirect_to admin_menu_items_path
    end
  end
end
