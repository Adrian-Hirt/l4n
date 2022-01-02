module Admin
  class MenuItemsController < AdminController
    add_breadcrumb _('Admin|MenuItem'), :admin_menu_items_path

    def index
      op Operations::Admin::MenuItem::Index
    end

    def new_link
      add_breadcrumb _('Admin|MenuItem|New Link')
      op Operations::Admin::MenuItem::CreateLink
    end

    def create_link
      if run Operations::Admin::MenuItem::CreateLink
        flash[:success] = _('MenuItem|Successfully created')
        redirect_to admin_menu_items_path
      else
        add_breadcrumb _('Admin|MenuItem|New Link')
        flash[:danger] = _('MenuItem|Create failed')
        render :new_link, status: :unprocessable_entity
      end
    end

    def new_dropdown
      add_breadcrumb _('Admin|MenuItem|New Dropdown')
      op Operations::Admin::MenuItem::CreateDropdown
    end

    def create_dropdown
      if run Operations::Admin::MenuItem::CreateDropdown
        flash[:success] = _('MenuItem|Successfully created')
        redirect_to admin_menu_items_path
      else
        add_breadcrumb _('Admin|MenuItem|New Dropdown')
        flash[:danger] = _('MenuItem|Create failed')
        render :new_dropdown, status: :unprocessable_entity
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
