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
        add_breadcrumb _('Admin|Promotion|New')
      end

      def create
        if run Operations::Admin::Promotion::Create
          flash[:success] = _('Admin|Promotion|Successfully created')
          redirect_to admin_shop_promotions_path
        else
          add_breadcrumb _('Admin|Promotion|New')
          flash[:danger] = _('Admin|Promotion|Create failed')
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::Promotion::Update
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Promotion::Update
          flash[:success] = _('Admin|Promotion|Successfully updated')
          redirect_to admin_shop_promotions_path
        else
          add_breadcrumb model.name
          flash[:danger] = _('Admin|Promotion|Edit failed')
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::Promotion::Destroy
          flash[:success] = _('Admin|Promotion|Successfully deleted')
        else
          flash[:danger] = _('Admin|Promotion|Cannot be deleted')
        end
        redirect_to admin_shop_promotions_path
      end
    end
  end
end
