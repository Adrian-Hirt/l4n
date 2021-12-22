module Operations::Admin::FeatureFlag
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, FeatureFlag
    end

    def flags
      @flags ||= FeatureFlag.order(:key)
    end

    def flag_warning_present?
      present_flags = flags.dup.map(&:key)

      unneeded_flags = present_flags - FeatureFlag::AVAILABLE_FLAGS
      missing_flags = FeatureFlag::AVAILABLE_FLAGS - present_flags

      unneeded_flags.any? || missing_flags.any?
    end
  end
end
