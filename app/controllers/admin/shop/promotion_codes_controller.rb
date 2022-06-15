module Admin
  module Shop
    class PromotionCodesController < AdminController
      def destroy
        if run Operations::Admin::PromotionCode::Destroy
          flash[:success] = _('Admin|PromotionCode|Successfully deleted')
        else
          flash[:danger] = _('Admin|PromotionCode|Cannot be deleted')
        end
      rescue ActiveRecord::RecordNotDestroyed
        flash[:danger] = _('Admin|PromotionCode|Cannot be deleted')
      ensure
        redirect_to admin_shop_promotion_path(model.promotion)
      end
    end
  end
end
