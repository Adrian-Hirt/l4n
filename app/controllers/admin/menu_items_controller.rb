module Admin
  class MenuItemsController < AdminController
    add_breadcrumb _('Admin|MenuItems'), :admin_menu_items_path

    def index
      op Operations::Admin::MenuItem::Index
    end

    def new_link
      add_breadcrumb _('Admin|MenuItem|New Link')
      op Operations::Admin::MenuItem::CreateLink
    end

    def create_link
      if run Operations::Admin::MenuItem::CreateLink
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('MenuItem') }
        redirect_to admin_menu_items_path
      else
        add_breadcrumb _('Admin|MenuItem|New Link')
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('MenuItem') }
        render :new_link, status: :unprocessable_entity
      end
    end

    def new_dropdown
      add_breadcrumb _('Admin|MenuItem|New Dropdown')
      op Operations::Admin::MenuItem::CreateDropdown
    end

    def create_dropdown
      if run Operations::Admin::MenuItem::CreateDropdown
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('MenuItem') }
        redirect_to admin_menu_items_path
      else
        add_breadcrumb _('Admin|MenuItem|New Dropdown')
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('MenuItem') }
        render :new_dropdown, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::MenuItem::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::MenuItem::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('MenuItem') }
        redirect_to admin_menu_items_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('MenuItem') }
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::MenuItem::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('MenuItem') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('MenuItem') }
      end
      redirect_to admin_menu_items_path
    end
  end
end
