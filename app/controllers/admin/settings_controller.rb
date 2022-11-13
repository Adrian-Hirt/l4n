module Admin
  class SettingsController < AdminController
    add_breadcrumb _('Admin|Settings'), :admin_settings_path

    def show
      op Operations::Admin::Settings::Index
    end

    def edit
      op Operations::Admin::Settings::Update
      add_breadcrumb _('Admin|Settings|Edit')
    end

    def update
      if run Operations::Admin::Settings::Update
        flash[:success] = _('Admin|Settings|Successfully updated')
        redirect_to admin_settings_path
      else
        add_breadcrumb _('Admin|Settings|Edit')
        flash[:danger] = _('Admin|Settings|Update failed')
        render :edit, status: :unprocessable_entity
      end
    end
  end
end
