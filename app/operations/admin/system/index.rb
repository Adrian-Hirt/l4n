module Operations::Admin::System
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, :system
    end

    def cache_space_usage
      return _('Admin|System|Cache size cannot be fetched') unless Rails.cache.is_a? ActiveSupport::Cache::FileStore

      result = `du -sh #{Rails.cache.cache_path}`
      if result.blank?
        _('Admin|System|Cache size cannot be fetched')
      else
        _('Admin|System|Cache size reported: %{size}') % { size: result.split("\t")[0] }
      end
    end
  end
end
