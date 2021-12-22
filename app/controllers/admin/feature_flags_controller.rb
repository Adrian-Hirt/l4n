module Admin
  class FeatureFlagsController < AdminController
    add_breadcrumb _('Admin|FeatureFlags'), :admin_feature_flags_path

    def index
      op Operations::Admin::FeatureFlag::Index
      flash[:warning] = _('FeatureFlag|Please re-initialize the flags, as not all are present and/or unneeded flags are present') if op.flag_warning_present?
    end

    def reinitialize
      op Operations::Admin::FeatureFlag::Reinitialize

      if op.run
        flash[:success] = _('FeatureFlag|Successfully reinitialized feature flags')
      else
        flash[:danger] = _('FeatureFlag|Could not reinitialize the feature flags')
      end

      redirect_to admin_feature_flags_path
    end

    def toggle
      op Operations::Admin::FeatureFlag::Toggle

      if op.run
        flash[:success] = _('FeatureFlag|Successfully toggled flag')
      else
        flash[:danger] = _('FeatureFlag|Could not toggle the flag')
      end

      redirect_to admin_feature_flags_path
    end
  end
end
