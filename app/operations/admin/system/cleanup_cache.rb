module Operations::Admin::System
  class CleanupCache < RailsOps::Operation
    policy :on_init do
      authorize! :manage, :system
    end

    def perform
      Rails.cache.cleanup
    end
  end
end
