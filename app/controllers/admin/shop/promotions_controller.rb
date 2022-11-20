module Admin
  module Shop
    class PromotionsController < AdminController
      add_breadcrumb _('Admin|Promotions'), :admin_shop_promotions_path

      def index
        op Operations::Admin::Promotion::Index
      end

      def show
        op Operations::Admin::Promotion::Load
        add_breadcrumb model.name
      end

      def new
        op Operations::Admin::Promotion::Create
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Promotion') }
      end

      def create
        if run Operations::Admin::Promotion::Create
          flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Promotion') }
          redirect_to admin_shop_promotions_path
        else
          add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Promotion') }
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Promotion') }
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::Promotion::Update
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Promotion::Update
          flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Promotion') }
          redirect_to admin_shop_promotions_path
        else
          add_breadcrumb model.name
          flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Promotion') }
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::Promotion::Destroy
          flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Promotion') }
        else
          flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Promotion') }
        end
        redirect_to admin_shop_promotions_path
      end

      def add_codes
        op Operations::Admin::Promotion::AddCodes
        add_breadcrumb model.name, admin_shop_promotion_path(model)
        add_breadcrumb _('Admin|Promotion|Add codes')
      end

      def generate_additional_codes
        if run Operations::Admin::Promotion::AddCodes
          flash[:success] = _('Admin|Promotion|Codes added')
          redirect_to admin_shop_promotion_path(model)
        else
          add_breadcrumb model.name, admin_shop_promotion_path(model)
          add_breadcrumb _('Admin|Promotion|Add codes')
          flash[:danger] = _('Admin|Promotion|Codes could not be added')
          render :add_codes, status: :unprocessable_entity
        end
      end

      def export_codes
        run Operations::Admin::Promotion::ExportCodes
        send_data op.data, filename: "promotion-codes-#{model.name}.csv"
      end
    end
  end
end
