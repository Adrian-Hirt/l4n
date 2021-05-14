class UsersController < ApplicationController
  before_action :check_captcha, only: %i[create]
  before_action :require_logged_in_user, only: %i[show profile]
  layout 'login_register', only: %i[new create]

  def new
    op Operations::User::Create
  end

  def create
    if run Operations::User::Create
      flash[:success] = _('User|Successfully created, check your mail for activation')
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    op Operations::User::Load
  end

  def activate
    run Operations::User::Activate
    flash[:success] = _('User|Successfully activated')
  rescue Operations::User::InvalidActivationError
    flash[:danger] = _('User|Activation invalid')
  ensure
    redirect_to root_path
  end

  private

  def check_captcha
    return if verify_hcaptcha

    op Operations::User::Create
    flash.delete(:hcaptcha_error)
    flash.now[:danger] = _('Session|Hcaptcha failed, please try again')
    render :new
  end
end
