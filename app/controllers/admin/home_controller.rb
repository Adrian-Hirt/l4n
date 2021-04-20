module Admin
  class HomeController < AdminController
    def index; end

    def settings
      add_breadcrumb _('Settings')
      op Operations::Admin::UserSettings::Update

      return unless request.patch?

      if op.run
        flash.now[:success] = _('Admin|Preferences updated successfully')
      else
        flash.now[:danger] = _('Admin|Preferences could not be updated')
      end
    end
  end
end
