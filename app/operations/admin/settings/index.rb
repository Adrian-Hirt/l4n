module Operations::Admin::Settings
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, AppConfig
    end

    def settings
      @settings ||= AppConfig.defined_fields.group_by { |field| field[:scope] }
    end
  end
end
