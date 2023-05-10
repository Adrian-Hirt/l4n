module Operations::Admin::Settings
  class Update < RailsOps::Operation
    schema3 do
      hsh? :app_config do
        str? :application_name
        str? :favicon_url
        boo? :enable_terms_and_conditions, cast_str: true
        str? :terms_and_conditions_url
        boo? :enable_lan_party_block, cast_str: true
        boo? :enable_events_block, cast_str: true
        boo? :enable_news_block, cast_str: true
        boo? :enforce_2fa_for_sensitive_admin, cast_str: true
      end
    end

    policy :on_init do
      authorize! :manage, AppConfig
    end

    def settings
      @settings ||= AppConfig.defined_fields.group_by { |field| field[:scope] }
    end

    def model
      @model ||= AppConfig.new
    end

    def entered_values
      @entered_values ||= {}
    end

    def perform
      ActiveRecord::Base.transaction do
        osparams.app_config.each do |key, value|
          next if value.nil?

          # This is only for validation
          config = AppConfig.new(var: key)
          config.value = value

          # Bookkeep the entered values
          entered_values[key] = value

          if config.valid?
            AppConfig.send("#{key}=", value)
          else
            model.errors.merge!(config.errors)
          end
        end

        fail RailsOps::Exceptions::ValidationFailed if model.errors.present?
      end
    end
  end
end
