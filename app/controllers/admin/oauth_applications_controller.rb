module Admin
  class OauthApplicationsController < Doorkeeper::ApplicationsController
    layout 'admin'

    # Skip this, as we don't need it. This is the method from
    # Doorkeeper, our auth is below
    skip_before_action :authenticate_admin!

    # The normal admin panel hooks
    before_action :authenticate_user!
    before_action :check_admin_panel_access
    before_action :clear_app_breadcrumbs

    before_action :grid, only: %i[index] # rubocop:disable Rails/LexicallyScopedActionFilter

    add_breadcrumb _('L4N Admin'), :admin_path
    add_breadcrumb _('Admin|OauthApplications'), :oauth_applications_path

    private

    def check_admin_panel_access
      authorize! :access, :admin_panel
      authorize! :manage, Doorkeeper::Application
    end

    def clear_app_breadcrumbs
      @breadcrumbs_on_rails = []
    end

    def grid
      @grid ||= Grids::Admin::OauthApplications.new(params[:grids_admin_oauth_applications]) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
