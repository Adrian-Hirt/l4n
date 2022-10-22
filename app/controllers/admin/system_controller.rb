module Admin
  class SystemController < AdminController
    add_breadcrumb _('Admin|System'), :admin_system_path

    def index
      op Operations::Admin::System::Index
    end

    def cleanup_cache
      run Operations::Admin::System::CleanupCache
      flash[:success] = _('Admin|System|Cache was cleaned')
      redirect_to admin_system_path
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      redirect_to admin_system_path
    end
  end
end
