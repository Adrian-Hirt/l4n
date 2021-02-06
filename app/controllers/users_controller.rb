class UsersController < ApplicationController
  def new
    op Operations::User::Create
  end

  def create
    if run Operations::User::Create
      redirect_to root_path
    else
      render :new
    end
  end

  def activate
    run Operations::User::Activate
    flash[:success] = _('User|Successfully activated')
  rescue Operations::User::InvalidActivationError
    flash[:danger] = _('User|Activation invalid')
  ensure
    redirect_to root_path
  end
end
