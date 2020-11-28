class UsersController < ApplicationController
  def new
    op Operations::User::Create
  end

  def create
    if run Operations::User::Create
      redirect_to root_path
    else
      render partial: 'form'
    end
  end
end
