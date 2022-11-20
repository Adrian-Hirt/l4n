module Admin
  module Shop
    class PromotionCodesController < AdminController
      def destroy
        if run Operations::Admin::PromotionCode::Destroy
          flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('PromotionCode') }
        else
          flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('PromotionCode') }
        end
      rescue ActiveRecord::RecordNotDestroyed
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('PromotionCode') }
      ensure
        redirect_to admin_shop_promotion_path(model.promotion)
      end
    end
  end
end
