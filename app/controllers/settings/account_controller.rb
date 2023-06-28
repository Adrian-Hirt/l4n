module Settings
  class AccountController < ApplicationController
    before_action :authenticate_user!

    add_breadcrumb _('Settings|Delete my account')

    def show
      op Operations::User::DeleteAccount
    end

    def delete
      if run Operations::User::DeleteAccount
        # Delete session and redirect to root_path
        reset_session
        flash[:success] = _('User|Account successfully deleted')
        redirect_to root_path
      else
        render :show
      end
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      redirect_to settings_account_path
    end
  end
end
