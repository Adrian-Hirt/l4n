module Admin
  module Tournaments
    class TeamMembersController < AdminController
      def destroy
        if run Operations::Admin::Tournament::TeamMember::Destroy
          flash[:success] = _('Admin|TeamMember|Successfully destroyed')
        else
          flash[:danger] = _('Admin|TeamMember|Destroying failed')
        end
      rescue Operations::Admin::Tournament::TeamMember::WrongState
        flash[:danger] = _('Admin|TeamMember|Team has state other than created and as such team cannot be deleted')
      ensure
        redirect_to admin_team_path(model)
      end

      def promote
        if run Operations::Admin::Tournament::TeamMember::Promote
          flash[:success] = _('Admin|TeamMember|Successfully promoted')
        else
          flash[:danger] = _('Admin|TeamMember|Promoting failed')
        end

        redirect_to admin_team_path(model)
      end
    end
  end
end
