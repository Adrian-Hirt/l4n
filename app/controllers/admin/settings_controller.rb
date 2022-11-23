module Admin
  class SettingsController < AdminController
    add_breadcrumb _('Admin|Settings'), :admin_settings_path

    def show
      op Operations::Admin::Settings::Index
    end

    def edit
      op Operations::Admin::Settings::Update
      add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('Settings') }
    end

    def update
      if run Operations::Admin::Settings::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Settings') }
        redirect_to admin_settings_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('Settings') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Settings') }
        render :edit, status: :unprocessable_entity
      end
    end
  end
end
