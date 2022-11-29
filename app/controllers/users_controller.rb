class UsersController < ApplicationController
  layout 'devise', only: %i[new create]

  def index
    op Operations::User::Index
    add_breadcrumb _('Users'), :users_path
  end

  def new
    add_breadcrumb _('Signup')
    op Operations::User::Create
  rescue Operations::User::SignupClosed
    flash[:danger] = _('User|Signup is currently closed')
    redirect_to root_path
  end

  def create
    op Operations::User::Create

    captcha_success = verify_recaptcha(model: model)

    if run && captcha_success
      flash[:success] = _('User|Successfully created, check your mail for activation')
      redirect_to root_path
    else
      add_breadcrumb _('Signup')
      if captcha_success
        flash.now[:danger] = _('User|Could not be created, please check the form below for more infos')
      else
        flash.now[:danger] = _('User|The captcha verification failed, please try again')
      end
      render :new
    end
  rescue Operations::User::SignupClosed
    flash[:danger] = _('User|Signup is currently closed')
    redirect_to root_path
  end

  def show
    op Operations::User::Load
    add_breadcrumb _('Users'), :users_path
    add_breadcrumb model.username
  end
end
