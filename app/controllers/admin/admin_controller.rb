module Admin
  class AdminController < ApplicationController
    # Base class for all controllers residing in the admin namespace
    # Do not put controller actions in here, but rather inherit from
    # this controller and add seperate controllers for each resource,
    # it's way cleaner that way
    layout 'admin'

    before_action :check_admin_panel_access

    private

    def check_admin_panel_access
      authorize! :access, :admin_panel
    end
  end
end
