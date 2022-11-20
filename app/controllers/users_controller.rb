class UsersController < ApplicationController
  before_action :check_captcha, only: %i[create]
  before_action :authenticate_user!, only: %i[show]
  layout 'devise', only: %i[new create]

  add_breadcrumb _('Users'), :users_path

  def index
    op Operations::User::Index
  end

  def new
    op Operations::User::Create
  rescue Operations::User::Create::SignupClosed
    flash[:danger] = _('User|Signup is currently closed')
    redirect_to root_path
  end

  def create
    if run Operations::User::Create
      flash[:success] = _('User|Successfully created, check your mail for activation')
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  rescue Operations::User::Create::SignupClosed
    flash[:danger] = _('User|Signup is currently closed')
    redirect_to root_path
  end

  def show
    op Operations::User::Load
    add_breadcrumb model.username
  end

  private

  def check_captcha
    return if verify_hcaptcha

    op Operations::User::Create
    model.validate
    flash.delete(:hcaptcha_error)
    flash.now[:danger] = _('Session|Hcaptcha failed, please try again')
    render :new, status: :unprocessable_entity
  end
end
