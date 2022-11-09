module Lan
  class LanController < ApplicationController
    # Base class for all controllers residing in the lan namespace
    # Do not put controller actions in here, but rather inherit from
    # this controller and add seperate controllers for each resource,
    # it's way cleaner that way
    before_action :check_lan_feature_flag
    before_action :check_lan_active
    before_action :authenticate_user!

    add_breadcrumb _('Lan')

    private

    def check_lan_feature_flag
      redirect_to root_path unless FeatureFlag.enabled?(:lan_party)
    end

    def check_lan_active
      redirect_to root_path unless LanParty.where(active: true).any?
    end
  end
end
