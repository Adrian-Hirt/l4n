module Operations::Admin::FeatureFlag
  class Reinitialize < RailsOps::Operation
    policy :on_init do
      authorize! :manage, FeatureFlag
    end

    def perform
      # Create flags which are not present yet
      FeatureFlag::AVAILABLE_FLAGS.each do |key|
        FeatureFlag.find_by(key: key) || FeatureFlag.create!(key: key)
      end

      # Delete flags which are not in available flags anymore
      FeatureFlag.find_each do |flag|
        next if FeatureFlag::AVAILABLE_FLAGS.include?(flag.key)

        # Delete the flag
        flag.destroy

        # Delete the cache entry
        Rails.cache.delete("feature_flag/#{flag.key}")
      end
    end
  end
end
