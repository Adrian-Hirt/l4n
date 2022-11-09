module Settings
  class UserAddressesController < ApplicationController
    before_action :authenticate_user!

    add_breadcrumb _('Settings|Addresses')

    def index; end

    def new
      op Operations::UserAddress::Create
    end

    def create
      if run Operations::UserAddress::Create
        flash[:success] = _('UserAddress|Successfully created')
        redirect_to settings_user_addresses_path
      else
        flash.now[:danger] = _('UserAddress|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::UserAddress::Update
    end

    def update
      if run Operations::UserAddress::Update
        flash[:success] = _('UserAddress|Successfully updated')
        redirect_to settings_user_addresses_path
      else
        flash.now[:danger] = _('UserAddress|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::UserAddress::Destroy
        flash[:success] = _('UserAddress|Successfully destroyed')
      else
        flash[:danger] = _('UserAddress|Could not be destroyed')
      end
      redirect_to settings_user_addresses_path
    end
  end
end
