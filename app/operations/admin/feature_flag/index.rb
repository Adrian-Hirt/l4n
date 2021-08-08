module Operations::Admin::FeatureFlag
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, FeatureFlag
    end

    def flags
      FeatureFlag.order(:key)
    end
  end
end
